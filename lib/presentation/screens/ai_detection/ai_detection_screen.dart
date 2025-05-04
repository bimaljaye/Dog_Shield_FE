import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dogshield_ai/core/constants/app_constants.dart';
import 'package:dogshield_ai/core/constants/app_theme.dart';
import 'dart:io';
import 'package:lottie/lottie.dart';

class AIDetectionScreen extends StatefulWidget {
  const AIDetectionScreen({super.key});

  @override
  State<AIDetectionScreen> createState() => _AIDetectionScreenState();
}

class _AIDetectionScreenState extends State<AIDetectionScreen> with TickerProviderStateMixin {
  bool _isLoading = false;
  bool _isAnalyzing = false;
  bool _hasResult = false;
  bool _detectionResult = false; // true = rabies detected, false = no rabies
  double _detectionConfidence = 0.0;
  String _errorMessage = '';
  
  File? _imageFile;
  File? _videoFile;
  bool _isVideoMode = false;
  
  late AnimationController _animationController;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _animationController.repeat();
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  Future<void> _pickImage() async {
    setState(() {
      _isLoading = true;
      _hasResult = false;
      _errorMessage = '';
    });
    
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to pick image: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _takePhoto() async {
    setState(() {
      _isLoading = true;
      _hasResult = false;
      _errorMessage = '';
    });
    
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1080,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _imageFile = File(image.path);
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to take photo: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _pickVideo() async {
    setState(() {
      _isLoading = true;
      _hasResult = false;
      _errorMessage = '';
    });
    
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: Duration(seconds: AppConstants.videoMaxDuration),
      );
      
      if (video != null) {
        setState(() {
          _videoFile = File(video.path);
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to pick video: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _recordVideo() async {
    setState(() {
      _isLoading = true;
      _hasResult = false;
      _errorMessage = '';
    });
    
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: Duration(seconds: AppConstants.videoMaxDuration),
      );
      
      if (video != null) {
        setState(() {
          _videoFile = File(video.path);
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to record video: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _analyzeMedia() async {
    // Check if we have a file to analyze
    if ((_isVideoMode && _videoFile == null) || (!_isVideoMode && _imageFile == null)) {
      setState(() {
        _errorMessage = 'Please select or capture ${_isVideoMode ? 'a video' : 'an image'} first';
      });
      return;
    }
    
    setState(() {
      _isAnalyzing = true;
      _errorMessage = '';
    });
    
    try {
      // TODO: Implement actual AI detection using TensorFlow Lite or ML Kit
      // For now, we'll simulate the analysis with a delay and random result
      await Future.delayed(const Duration(seconds: 3));
      
      // Simulated result - would be replaced with actual model inference
      final bool hasRabies = DateTime.now().millisecondsSinceEpoch % 3 == 0; // 1/3 chance of detection
      final double confidence = 0.55 + (DateTime.now().millisecondsSinceEpoch % 40) / 100;
      
      setState(() {
        _hasResult = true;
        _detectionResult = hasRabies;
        _detectionConfidence = confidence;
      });
      
      // Save detection history
      // TODO: Implement saving to Firebase
      
    } catch (e) {
      setState(() {
        _errorMessage = 'Analysis failed: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }
  
  void _resetDetection() {
    setState(() {
      _imageFile = null;
      _videoFile = null;
      _hasResult = false;
      _errorMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Rabies Detection'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.pushNamed(context, AppConstants.detectionHistoryRoute);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mode Selection
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Detection Mode',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isVideoMode = false;
                                  _resetDetection();
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: !_isVideoMode
                                      ? AppTheme.primaryColor
                                      : AppTheme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.image,
                                        color: !_isVideoMode ? Colors.white : AppTheme.primaryColor,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Image',
                                        style: TextStyle(
                                          color: !_isVideoMode ? Colors.white : AppTheme.primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isVideoMode = true;
                                  _resetDetection();
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: _isVideoMode
                                      ? AppTheme.primaryColor
                                      : AppTheme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.videocam,
                                        color: _isVideoMode ? Colors.white : AppTheme.primaryColor,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Video',
                                        style: TextStyle(
                                          color: _isVideoMode ? Colors.white : AppTheme.primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Media Preview
              _buildMediaPreview(),
              const SizedBox(height: 24),
              
              // Capture Buttons
              _hasResult ? _buildResultSection() : _buildCaptureButtons(),
              
              // Error Message
              if (_errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    _errorMessage,
                    style: TextStyle(
                      color: AppTheme.errorColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildMediaPreview() {
    if (_isAnalyzing) {
      return _buildAnalyzingState();
    }
    
    if (_isVideoMode) {
      if (_videoFile == null) {
        return _buildEmptyState(
          icon: Icons.videocam,
          message: 'Record or upload a video\nof your dog\'s behavior',
        );
      } else {
        // In a real app, you would use a video player here
        return Container(
          height: 300,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.videocam,
                size: 60,
                color: Colors.white.withOpacity(0.6),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.black.withOpacity(0.5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Video selected (Tap to play)',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    } else {
      if (_imageFile == null) {
        return _buildEmptyState(
          icon: Icons.photo_camera,
          message: 'Take or upload a photo\nof your dog',
        );
      } else {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(
            _imageFile!,
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
          ),
        );
      }
    }
  }
  
  Widget _buildEmptyState({
    required IconData icon,
    required String message,
  }) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.3),
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: AppTheme.primaryColor.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAnalyzingState() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Using Lottie animation for the analyzing state
          Lottie.asset(
            '${AppConstants.animationPath}analyzing.json',
            width: 150,
            height: 150,
            controller: _animationController,
          ),
          const SizedBox(height: 24),
          Text(
            'Analyzing...',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Our AI is analyzing your ${_isVideoMode ? 'video' : 'image'}',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.primaryColor.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCaptureButtons() {
    return Column(
      children: [
        // Upload from Gallery / Library
        ElevatedButton.icon(
          onPressed: _isLoading
              ? null
              : _isVideoMode
                  ? _pickVideo
                  : _pickImage,
          icon: Icon(_isVideoMode ? Icons.video_library : Icons.photo_library),
          label: Text('Upload from ${_isVideoMode ? 'Library' : 'Gallery'}'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 16),
        
        // Take Photo / Record Video
        ElevatedButton.icon(
          onPressed: _isLoading
              ? null
              : _isVideoMode
                  ? _recordVideo
                  : _takePhoto,
          icon: Icon(_isVideoMode ? Icons.videocam : Icons.camera_alt),
          label: Text(_isVideoMode ? 'Record Video' : 'Take Photo'),
        ),
        const SizedBox(height: 24),
        
        // Analyze Button (only shown if media is selected)
        if ((_isVideoMode && _videoFile != null) || (!_isVideoMode && _imageFile != null))
          ElevatedButton.icon(
            onPressed: _isLoading || _isAnalyzing ? null : _analyzeMedia,
            icon: const Icon(Icons.search),
            label: const Text('Analyze for Rabies Symptoms'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
      ],
    );
  }
  
  Widget _buildResultSection() {
    final resultColor = _detectionResult ? AppTheme.errorColor : AppTheme.successColor;
    final confidencePercentage = (_detectionConfidence * 100).toStringAsFixed(1);
    
    return Card(
      color: resultColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: resultColor,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(
              _detectionResult ? Icons.warning_amber_rounded : Icons.check_circle,
              size: 70,
              color: resultColor,
            ),
            const SizedBox(height: 16),
            Text(
              _detectionResult ? 'Rabies Symptoms Detected' : 'No Rabies Symptoms Detected',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: resultColor,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Confidence: $confidencePercentage%',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: resultColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _detectionResult
                  ? 'Our AI has detected patterns that may indicate rabies symptoms. Please consult a veterinarian immediately for proper diagnosis.'
                  : 'Our AI did not detect any signs of rabies in this ${_isVideoMode ? 'video' : 'image'}. Continue to monitor your pet\'s behavior.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            if (_detectionResult)
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement find vet feature
                },
                icon: const Icon(Icons.local_hospital),
                label: const Text('Find Nearby Vet'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                ),
              )
            else
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement reminder setting
                },
                icon: const Icon(Icons.calendar_today),
                label: const Text('Set Regular Check Reminder'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                ),
              ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _resetDetection,
              icon: const Icon(Icons.refresh),
              label: const Text('Perform Another Detection'),
            ),
          ],
        ),
      ),
    );
  }
} 