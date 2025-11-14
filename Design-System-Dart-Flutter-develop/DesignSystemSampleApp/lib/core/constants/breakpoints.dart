/// Breakpoints para design responsivo
/// Define os pontos de quebra para diferentes tamanhos de tela
library;

// ==================== BREAKPOINTS ====================

/// 640px - Mobile large / Tablet portrait pequeno
const double breakpointSM = 640.0;

/// 768px - Tablet portrait
const double breakpointMD = 768.0;

/// 1024px - Tablet landscape / Desktop pequeno
const double breakpointLG = 1024.0;

/// 1280px - Desktop médio
const double breakpointXL = 1280.0;

/// 1536px - Desktop grande
const double breakpoint2XL = 1536.0;

// ==================== HELPERS ====================

/// Verifica se está em mobile (< 640px)
bool isMobile(double width) => width < breakpointSM;

/// Verifica se está em tablet (>= 640px e < 1024px)
bool isTablet(double width) => width >= breakpointSM && width < breakpointLG;

/// Verifica se está em desktop (>= 1024px)
bool isDesktop(double width) => width >= breakpointLG;
