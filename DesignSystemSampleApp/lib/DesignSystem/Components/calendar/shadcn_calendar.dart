import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'calendar_view_model.dart';

/// Componente de Calendário estilo shadcn/ui
/// 
/// Um calendário minimalista e elegante com suporte a:
/// - Seleção de data
/// - Navegação entre meses
/// - Data mínima/máxima
/// - Destaque de hoje
/// - Animações suaves
class ShadcnCalendar extends StatefulWidget {
  final CalendarViewModel viewModel;
  final String? label;
  final String? placeholder;
  final String? error;
  final bool enabled;
  
  const ShadcnCalendar({
    super.key,
    required this.viewModel,
    this.label,
    this.placeholder,
    this.error,
    this.enabled = true,
  });

  @override
  State<ShadcnCalendar> createState() => _ShadcnCalendarState();
}

class _ShadcnCalendarState extends State<ShadcnCalendar> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;
  late Animation<double> _fadeAnimation;
  late TextEditingController _textController;
  final FocusNode _focusNode = FocusNode();
  bool _isEditing = false;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _heightAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    
    _textController = TextEditingController(
      text: widget.viewModel.selectedDate != null 
          ? widget.viewModel.formattedDate 
          : '',
    );
    
    // Ouve mudanças no viewModel
    widget.viewModel.addListener(_onViewModelChanged);
    
    // Inicia animação se já estiver aberto
    if (widget.viewModel.isOpen) {
      _animationController.value = 1.0;
    }
  }
  
  void _onViewModelChanged() {
    if (mounted) {
      if (widget.viewModel.isOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
      
      // Atualiza o texto se a data foi selecionada pelo calendário
      if (!_isEditing && widget.viewModel.selectedDate != null) {
        _textController.text = widget.viewModel.formattedDate;
      }
      
      setState(() {});
    }
  }
  
  void _onTextChanged(String value) {
    _isEditing = true;
    _applyDateMask(value);
  }
  
  void _applyDateMask(String value) {
    // Remove tudo que não é número
    String digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    // Limita a 8 dígitos (ddMMyyyy)
    if (digitsOnly.length > 8) {
      digitsOnly = digitsOnly.substring(0, 8);
    }
    
    // Aplica a máscara dd/MM/yyyy
    String formatted = '';
    for (int i = 0; i < digitsOnly.length; i++) {
      if (i == 2 || i == 4) {
        formatted += '/';
      }
      formatted += digitsOnly[i];
    }
    
    // Atualiza o controller sem disparar listener recursivo
    if (_textController.text != formatted) {
      _textController.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
    
    // Tenta parsear a data se tiver 10 caracteres (dd/MM/yyyy)
    if (formatted.length == 10) {
      _tryParseDate(formatted);
    }
  }
  
  void _tryParseDate(String value) {
    try {
      final parts = value.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        
        // Valida a data
        if (day >= 1 && day <= 31 && month >= 1 && month <= 12 && year >= 1900 && year <= 2100) {
          final date = DateTime(year, month, day);
          
          // Verifica se a data é válida (ex: 31/02 seria inválido)
          if (date.day == day && date.month == month && date.year == year) {
            widget.viewModel.selectDate(date);
          }
        }
      }
    } catch (e) {
      // Ignora erros de parsing
    }
  }
  
  void _onEditingComplete() {
    _isEditing = false;
    _focusNode.unfocus();
    
    // Se não tem data válida selecionada, limpa o campo
    if (widget.viewModel.selectedDate == null) {
      _textController.clear();
    } else {
      _textController.text = widget.viewModel.formattedDate;
    }
  }
  
  @override
  void dispose() {
    widget.viewModel.removeListener(_onViewModelChanged);
    _animationController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.error != null;
    final hasValue = widget.viewModel.selectedDate != null;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF18181B),
            ),
          ),
          const SizedBox(height: 8),
        ],
        
        // Campo de entrada com máscara de data
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 52,
          decoration: BoxDecoration(
            color: widget.enabled ? Colors.white : const Color(0xFFF4F4F5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError 
                  ? const Color(0xFFEF4444)
                  : widget.viewModel.isOpen || _focusNode.hasFocus
                      ? const Color(0xFF18181B)
                      : const Color(0xFFE4E4E7),
              width: widget.viewModel.isOpen || hasError || _focusNode.hasFocus ? 1.5 : 1,
            ),
            boxShadow: widget.viewModel.isOpen || _focusNode.hasFocus
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Botão do calendário
              GestureDetector(
                onTap: widget.enabled ? () => widget.viewModel.toggle() : null,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: double.infinity,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.calendar_today_outlined,
                    size: 20,
                    color: hasValue 
                        ? const Color(0xFF18181B) 
                        : const Color(0xFFA1A1AA),
                  ),
                ),
              ),
              // Campo de texto
              Expanded(
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  enabled: widget.enabled,
                  keyboardType: TextInputType.number,
                  onChanged: _onTextChanged,
                  onEditingComplete: _onEditingComplete,
                  textAlignVertical: TextAlignVertical.center,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF18181B),
                  ),
                  decoration: InputDecoration(
                    hintText: widget.placeholder ?? 'dd/mm/aaaa',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFFA1A1AA),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              // Botão para abrir/fechar calendário
              GestureDetector(
                onTap: widget.enabled ? () => widget.viewModel.toggle() : null,
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: double.infinity,
                  alignment: Alignment.center,
                  child: AnimatedRotation(
                    turns: widget.viewModel.isOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 20,
                      color: Color(0xFFA1A1AA),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Erro
        if (hasError) ...[
          const SizedBox(height: 6),
          Text(
            widget.error!,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: const Color(0xFFEF4444),
            ),
          ),
        ],
        
        // Calendário expandível
        SizeTransition(
          sizeFactor: _heightAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _CalendarDropdown(viewModel: widget.viewModel),
            ),
          ),
        ),
      ],
    );
  }
}

/// Dropdown do calendário
class _CalendarDropdown extends StatelessWidget {
  final CalendarViewModel viewModel;
  
  const _CalendarDropdown({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E4E7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header com navegação
          _buildHeader(),
          
          // Dias da semana
          _buildWeekDays(),
          
          // Grade de dias
          _buildDaysGrid(),
          
          const SizedBox(height: 8),
        ],
      ),
    );
  }
  
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavigationButton(
            icon: Icons.chevron_left_rounded,
            onTap: viewModel.previousMonth,
          ),
          Text(
            viewModel.currentMonthName,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF18181B),
            ),
          ),
          _NavigationButton(
            icon: Icons.chevron_right_rounded,
            onTap: viewModel.nextMonth,
          ),
        ],
      ),
    );
  }
  
  Widget _buildWeekDays() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: viewModel.weekDays.map((day) {
          return Expanded(
            child: Center(
              child: Text(
                day,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF71717A),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
  
  Widget _buildDaysGrid() {
    final days = viewModel.calendarDays;
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
      child: Column(
        children: List.generate(6, (weekIndex) {
          return Row(
            children: List.generate(7, (dayIndex) {
              final index = weekIndex * 7 + dayIndex;
              final day = days[index];
              return Expanded(
                child: _DayCell(
                  day: day,
                  onTap: () => viewModel.selectDate(day.date),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}

/// Botão de navegação do calendário
class _NavigationButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  
  const _NavigationButton({
    required this.icon,
    required this.onTap,
  });

  @override
  State<_NavigationButton> createState() => _NavigationButtonState();
}

class _NavigationButtonState extends State<_NavigationButton> {
  bool _isHovered = false;
  
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: _isHovered ? const Color(0xFFF4F4F5) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isHovered ? const Color(0xFFE4E4E7) : Colors.transparent,
            ),
          ),
          child: Icon(
            widget.icon,
            size: 20,
            color: const Color(0xFF71717A),
          ),
        ),
      ),
    );
  }
}

/// Célula de dia no calendário
class _DayCell extends StatefulWidget {
  final CalendarDay day;
  final VoidCallback onTap;
  
  const _DayCell({
    required this.day,
    required this.onTap,
  });

  @override
  State<_DayCell> createState() => _DayCellState();
}

class _DayCellState extends State<_DayCell> {
  bool _isHovered = false;
  
  @override
  Widget build(BuildContext context) {
    final day = widget.day;
    
    Color backgroundColor;
    Color textColor;
    FontWeight fontWeight = FontWeight.w400;
    
    if (day.isSelected) {
      backgroundColor = const Color(0xFF18181B);
      textColor = Colors.white;
      fontWeight = FontWeight.w500;
    } else if (day.isToday) {
      backgroundColor = const Color(0xFFF4F4F5);
      textColor = const Color(0xFF18181B);
      fontWeight = FontWeight.w600;
    } else if (_isHovered && !day.isDisabled && day.isCurrentMonth) {
      backgroundColor = const Color(0xFFF4F4F5);
      textColor = const Color(0xFF18181B);
    } else {
      backgroundColor = Colors.transparent;
      textColor = day.isCurrentMonth 
          ? (day.isDisabled ? const Color(0xFFD4D4D8) : const Color(0xFF18181B))
          : const Color(0xFFD4D4D8);
    }
    
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: day.isDisabled || !day.isCurrentMonth ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.all(2),
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              '${day.date.day}',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: fontWeight,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
