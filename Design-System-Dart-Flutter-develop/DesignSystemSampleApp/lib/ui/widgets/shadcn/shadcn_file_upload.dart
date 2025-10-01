import 'package:flutter/material.dart';
import 'dart:io';

enum ShadcnFileUploadType {
  single,
  multiple,
  dragDrop,
}

enum ShadcnFileUploadStatus {
  idle,
  uploading,
  success,
  error,
}

class ShadcnFileUpload extends StatefulWidget {
  final String? label;
  final String? description;
  final List<String>? acceptedFileTypes;
  final int? maxFiles;
  final int? maxFileSize; // em MB
  final ShadcnFileUploadType type;
  final ValueChanged<List<File>>? onFilesSelected;
  final ValueChanged<File>? onFileSelected;
  final VoidCallback? onUploadComplete;
  final ValueChanged<String>? onError;
  final bool enabled;
  final Widget? icon;
  final String? buttonText;
  final String? dragText;

  const ShadcnFileUpload({
    super.key,
    this.label,
    this.description,
    this.acceptedFileTypes,
    this.maxFiles,
    this.maxFileSize,
    this.type = ShadcnFileUploadType.single,
    this.onFilesSelected,
    this.onFileSelected,
    this.onUploadComplete,
    this.onError,
    this.enabled = true,
    this.icon,
    this.buttonText,
    this.dragText,
  });

  @override
  State<ShadcnFileUpload> createState() => _ShadcnFileUploadState();
}

class _ShadcnFileUploadState extends State<ShadcnFileUpload> {
  List<UploadedFile> _uploadedFiles = [];
  bool _isDragOver = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
        ],
        
        if (widget.description != null) ...[
          Text(
            widget.description!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
        ],

        // Upload Area
        GestureDetector(
          onTap: widget.enabled ? _selectFiles : null,
          child: DragTarget<File>(
            onWillAccept: (data) => widget.enabled,
            onAccept: (file) => _handleFileSelected([file]),
            onMove: (details) => setState(() => _isDragOver = true),
            onLeave: (details) => setState(() => _isDragOver = false),
            builder: (context, candidateData, rejectedData) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _isDragOver 
                        ? colorScheme.primary 
                        : colorScheme.outline.withValues(alpha: 0.5),
                    width: _isDragOver ? 2 : 1,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: _isDragOver 
                      ? colorScheme.primary.withValues(alpha: 0.05)
                      : colorScheme.surface,
                ),
                child: Column(
                  children: [
                    // Ãcone
                    widget.icon ?? Icon(
                      _getUploadIcon(),
                      size: 48,
                      color: _isDragOver 
                          ? colorScheme.primary 
                          : colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(height: 16),
                    
                    // Texto principal
                    Text(
                      widget.type == ShadcnFileUploadType.dragDrop 
                          ? (widget.dragText ?? 'Arraste arquivos aqui ou clique para selecionar')
                          : (widget.buttonText ?? 'Clique para selecionar arquivos'),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: _isDragOver 
                            ? colorScheme.primary 
                            : colorScheme.onSurface,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // InformaÃ§Ãµes de formato
                    if (widget.acceptedFileTypes != null) ...[
                      Text(
                        'Formatos aceitos: ${widget.acceptedFileTypes!.join(', ')}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    
                    if (widget.maxFileSize != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'Tamanho mÃ¡ximo: ${widget.maxFileSize}MB',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),

        // Lista de arquivos selecionados
        if (_uploadedFiles.isNotEmpty) ...[
          const SizedBox(height: 16),
          ...List.generate(_uploadedFiles.length, (index) {
            final file = _uploadedFiles[index];
            return _buildFileItem(file, index);
          }),
        ],
      ],
    );
  }

  Widget _buildFileItem(UploadedFile file, int index) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(8),
        color: colorScheme.surfaceContainerLowest,
      ),
      child: Row(
        children: [
          // Ãcone do arquivo
          Icon(
            _getFileIcon(file.name),
            color: _getStatusColor(file.status),
            size: 24,
          ),
          const SizedBox(width: 12),
          
          // InformaÃ§Ãµes do arquivo
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      _formatFileSize(file.size),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getStatusText(file.status),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: _getStatusColor(file.status),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Progress indicator ou botÃ£o de remover
          if (file.status == ShadcnFileUploadStatus.uploading) ...[
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                value: file.progress,
              ),
            ),
          ] else ...[
            IconButton(
              onPressed: () => _removeFile(index),
              icon: Icon(
                Icons.close,
                size: 18,
                color: colorScheme.onSurfaceVariant,
              ),
              constraints: const BoxConstraints.tightFor(width: 32, height: 32),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getUploadIcon() {
    switch (widget.type) {
      case ShadcnFileUploadType.dragDrop:
        return Icons.cloud_upload_outlined;
      case ShadcnFileUploadType.multiple:
        return Icons.upload_file;
      default:
        return Icons.attach_file;
    }
  }

  IconData _getFileIcon(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'mp4':
      case 'avi':
      case 'mov':
        return Icons.video_file;
      case 'mp3':
      case 'wav':
        return Icons.audio_file;
      case 'zip':
      case 'rar':
        return Icons.archive;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getStatusColor(ShadcnFileUploadStatus status) {
    final colorScheme = Theme.of(context).colorScheme;
    
    switch (status) {
      case ShadcnFileUploadStatus.success:
        return Colors.green;
      case ShadcnFileUploadStatus.error:
        return colorScheme.error;
      case ShadcnFileUploadStatus.uploading:
        return colorScheme.primary;
      default:
        return colorScheme.onSurfaceVariant;
    }
  }

  String _getStatusText(ShadcnFileUploadStatus status) {
    switch (status) {
      case ShadcnFileUploadStatus.success:
        return 'Enviado';
      case ShadcnFileUploadStatus.error:
        return 'Erro';
      case ShadcnFileUploadStatus.uploading:
        return 'Enviando...';
      default:
        return 'Pronto';
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  void _selectFiles() async {
    // Simular seleÃ§Ã£o de arquivos
    // Na implementaÃ§Ã£o real, usaria file_picker ou similar
    
    final mockFiles = [
      File('documento.pdf'),
      File('imagem.jpg'),
    ];
    
    _handleFileSelected(mockFiles);
  }

  void _handleFileSelected(List<File> files) {
    for (final file in files) {
      // ValidaÃ§Ãµes
      if (!_validateFile(file)) continue;
      
      final uploadedFile = UploadedFile(
        file: file,
        name: file.path.split('/').last,
        size: 1024 * 512, // Mock size
        status: ShadcnFileUploadStatus.idle,
      );
      
      setState(() {
        if (widget.type == ShadcnFileUploadType.single) {
          _uploadedFiles = [uploadedFile];
        } else {
          _uploadedFiles.add(uploadedFile);
        }
      });
      
      // Simular upload
      _simulateUpload(uploadedFile);
    }
    
    // Callbacks
    if (widget.type == ShadcnFileUploadType.single && files.isNotEmpty) {
      widget.onFileSelected?.call(files.first);
    } else {
      widget.onFilesSelected?.call(files);
    }
  }

  bool _validateFile(File file) {
    final fileName = file.path.split('/').last;
    final extension = fileName.split('.').last.toLowerCase();
    
    // Validar tipo de arquivo
    if (widget.acceptedFileTypes != null && 
        !widget.acceptedFileTypes!.contains(extension)) {
      widget.onError?.call('Tipo de arquivo nÃ£o aceito: $extension');
      return false;
    }
    
    // Validar nÃºmero mÃ¡ximo de arquivos
    if (widget.maxFiles != null && _uploadedFiles.length >= widget.maxFiles!) {
      widget.onError?.call('NÃºmero mÃ¡ximo de arquivos excedido');
      return false;
    }
    
    return true;
  }

  void _simulateUpload(UploadedFile file) async {
    setState(() {
      file.status = ShadcnFileUploadStatus.uploading;
    });
    
    // Simular progresso de upload
    for (double progress = 0.0; progress <= 1.0; progress += 0.1) {
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() {
        file.progress = progress;
      });
    }
    
    // Simular sucesso ou erro
    setState(() {
      file.status = ShadcnFileUploadStatus.success;
      file.progress = 1.0;
    });
    
    widget.onUploadComplete?.call();
  }

  void _removeFile(int index) {
    setState(() {
      _uploadedFiles.removeAt(index);
    });
  }
}

class UploadedFile {
  final File file;
  final String name;
  final int size;
  ShadcnFileUploadStatus status;
  double progress;

  UploadedFile({
    required this.file,
    required this.name,
    required this.size,
    required this.status,
    this.progress = 0.0,
  });
}
