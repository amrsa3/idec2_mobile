import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

/// File upload progress indicator
class FileUploadProgress extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final String? fileName;
  final String? status;
  final VoidCallback? onCancel;
  final bool showPercentage;

  const FileUploadProgress({
    super.key,
    required this.progress,
    this.fileName,
    this.status,
    this.onCancel,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).round();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (fileName != null)
                      Text(
                        fileName!,
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (status != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        status!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getStatusColor(context),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (showPercentage)
                Text(
                  '$percentage%',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (onCancel != null) ...[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: onCancel,
                  icon: const Icon(Icons.close),
                  iconSize: 20,
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.primary.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              _getProgressColor(context),
            ),
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(BuildContext context) {
    if (status == null) return Theme.of(context).textTheme.bodySmall!.color!;
    
    if (status!.toLowerCase().contains('error') || 
        status!.toLowerCase().contains('failed')) {
      return Theme.of(context).colorScheme.error;
    }
    
    if (status!.toLowerCase().contains('complete') || 
        status!.toLowerCase().contains('success')) {
      return Colors.green;
    }
    
    return Theme.of(context).textTheme.bodySmall!.color!;
  }

  Color _getProgressColor(BuildContext context) {
    if (progress >= 1.0) {
      return Colors.green;
    }
    
    if (status != null && (status!.toLowerCase().contains('error') || 
        status!.toLowerCase().contains('failed'))) {
      return Theme.of(context).colorScheme.error;
    }
    
    return AppColors.primary;
  }
}

/// Step progress indicator
class StepProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String>? stepLabels;
  final Color? activeColor;
  final Color? inactiveColor;
  final double? height;

  const StepProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.stepLabels,
    this.activeColor,
    this.inactiveColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveActiveColor = activeColor ?? AppColors.primary;
    final effectiveInactiveColor = inactiveColor ?? Colors.grey.shade300;
    final effectiveHeight = height ?? 4.0;

    return Column(
      children: [
        Row(
          children: List.generate(totalSteps, (index) {
            final isActive = index < currentStep;
            final isCurrent = index == currentStep;
            
            return Expanded(
              child: Container(
                height: effectiveHeight,
                margin: EdgeInsets.only(
                  right: index < totalSteps - 1 ? 4 : 0,
                ),
                decoration: BoxDecoration(
                  color: isActive || isCurrent 
                      ? effectiveActiveColor 
                      : effectiveInactiveColor,
                  borderRadius: BorderRadius.circular(effectiveHeight / 2),
                ),
              ),
            );
          }),
        ),
        if (stepLabels != null && stepLabels!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: stepLabels!.asMap().entries.map((entry) {
              final index = entry.key;
              final label = entry.value;
              final isActive = index <= currentStep;
              
              return Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isActive 
                        ? effectiveActiveColor 
                        : effectiveInactiveColor,
                    fontWeight: index == currentStep 
                        ? FontWeight.bold 
                        : FontWeight.normal,
                  ),
                  textAlign: index == 0 
                      ? TextAlign.start 
                      : index == stepLabels!.length - 1 
                          ? TextAlign.end 
                          : TextAlign.center,
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

/// Circular progress with percentage
class CircularProgressWithPercentage extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Color? progressColor;
  final Color? backgroundColor;
  final bool showPercentage;
  final TextStyle? textStyle;

  const CircularProgressWithPercentage({
    super.key,
    required this.progress,
    this.size = 80,
    this.strokeWidth = 6,
    this.progressColor,
    this.backgroundColor,
    this.showPercentage = true,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveProgressColor = progressColor ?? AppColors.primary;
    final effectiveBackgroundColor = backgroundColor ?? Colors.grey.shade300;
    final percentage = (progress * 100).round();

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation<Color>(effectiveProgressColor),
              backgroundColor: effectiveBackgroundColor,
            ),
          ),
          if (showPercentage)
            Text(
              '$percentage%',
              style: textStyle ?? Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: effectiveProgressColor,
              ),
            ),
        ],
      ),
    );
  }
}

/// Loading overlay for entire screen
class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? message;
  final Color? overlayColor;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.message,
    this.overlayColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: overlayColor ?? Colors.black54,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  if (message != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      message!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}
