import 'package:flutter/material.dart';

/// Delegate para o componente de Calendário
abstract class CalendarDelegate {
  void onDateSelected(DateTime date);
}

/// ViewModel para o componente de Calendário estilo shadcn
class CalendarViewModel extends ChangeNotifier {
  final CalendarDelegate? delegate;
  final DateTime? initialDate;
  final DateTime? minDate;
  final DateTime? maxDate;
  
  CalendarViewModel({
    this.delegate,
    this.initialDate,
    this.minDate,
    this.maxDate,
  }) {
    _selectedDate = initialDate;
    _currentMonth = initialDate ?? DateTime.now();
  }
  
  // Estado
  DateTime? _selectedDate;
  DateTime? get selectedDate => _selectedDate;
  
  late DateTime _currentMonth;
  DateTime get currentMonth => _currentMonth;
  
  bool _isOpen = false;
  bool get isOpen => _isOpen;
  
  /// Primeiro dia do mês atual
  DateTime get firstDayOfMonth => DateTime(_currentMonth.year, _currentMonth.month, 1);
  
  /// Último dia do mês atual
  DateTime get lastDayOfMonth => DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
  
  /// Dias da semana (abreviados)
  List<String> get weekDays => ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
  
  /// Nome do mês atual
  String get currentMonthName {
    const months = [
      'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
      'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];
    return '${months[_currentMonth.month - 1]} ${_currentMonth.year}';
  }
  
  /// Gera os dias do calendário (incluindo dias do mês anterior/próximo para preencher a grade)
  List<CalendarDay> get calendarDays {
    final days = <CalendarDay>[];
    
    // Dias do mês anterior para preencher a primeira semana
    final firstWeekday = firstDayOfMonth.weekday % 7; // Domingo = 0
    final prevMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    final daysInPrevMonth = DateTime(prevMonth.year, prevMonth.month + 1, 0).day;
    
    for (int i = firstWeekday - 1; i >= 0; i--) {
      final day = daysInPrevMonth - i;
      days.add(CalendarDay(
        date: DateTime(prevMonth.year, prevMonth.month, day),
        isCurrentMonth: false,
        isDisabled: true,
      ));
    }
    
    // Dias do mês atual
    final daysInMonth = lastDayOfMonth.day;
    final today = DateTime.now();
    
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      final isDisabled = _isDateDisabled(date);
      final isToday = date.year == today.year && 
                      date.month == today.month && 
                      date.day == today.day;
      final isSelected = _selectedDate != null &&
                        date.year == _selectedDate!.year &&
                        date.month == _selectedDate!.month &&
                        date.day == _selectedDate!.day;
      
      days.add(CalendarDay(
        date: date,
        isCurrentMonth: true,
        isDisabled: isDisabled,
        isToday: isToday,
        isSelected: isSelected,
      ));
    }
    
    // Dias do próximo mês para preencher a última semana
    final remainingDays = 42 - days.length; // 6 semanas x 7 dias
    for (int day = 1; day <= remainingDays; day++) {
      days.add(CalendarDay(
        date: DateTime(_currentMonth.year, _currentMonth.month + 1, day),
        isCurrentMonth: false,
        isDisabled: true,
      ));
    }
    
    return days;
  }
  
  /// Verifica se uma data está desabilitada
  bool _isDateDisabled(DateTime date) {
    if (minDate != null && date.isBefore(DateTime(minDate!.year, minDate!.month, minDate!.day))) {
      return true;
    }
    if (maxDate != null && date.isAfter(DateTime(maxDate!.year, maxDate!.month, maxDate!.day))) {
      return true;
    }
    return false;
  }
  
  /// Abre o calendário
  void open() {
    _isOpen = true;
    notifyListeners();
  }
  
  /// Fecha o calendário
  void close() {
    _isOpen = false;
    notifyListeners();
  }
  
  /// Alterna estado aberto/fechado
  void toggle() {
    _isOpen = !_isOpen;
    notifyListeners();
  }
  
  /// Vai para o mês anterior
  void previousMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    notifyListeners();
  }
  
  /// Vai para o próximo mês
  void nextMonth() {
    _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    notifyListeners();
  }
  
  /// Seleciona uma data
  void selectDate(DateTime date) {
    if (_isDateDisabled(date)) return;
    
    _selectedDate = date;
    _isOpen = false;
    notifyListeners();
    
    delegate?.onDateSelected(date);
  }
  
  /// Limpa a data selecionada
  void clearDate() {
    _selectedDate = null;
    notifyListeners();
  }
  
  /// Formata a data selecionada para exibição
  String get formattedDate {
    if (_selectedDate == null) return '';
    return '${_selectedDate!.day.toString().padLeft(2, '0')}/'
           '${_selectedDate!.month.toString().padLeft(2, '0')}/'
           '${_selectedDate!.year}';
  }
}

/// Representa um dia no calendário
class CalendarDay {
  final DateTime date;
  final bool isCurrentMonth;
  final bool isDisabled;
  final bool isToday;
  final bool isSelected;
  
  CalendarDay({
    required this.date,
    required this.isCurrentMonth,
    this.isDisabled = false,
    this.isToday = false,
    this.isSelected = false,
  });
}
