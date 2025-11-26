import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'forgot_password_view_model.dart';
import '../../../DesignSystem/Components/calendar/shadcn_calendar.dart';

/// ForgotPasswordView - Tela de recuperação de senha
class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    
    final viewModel = context.watch<ForgotPasswordViewModel>();
    
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildBackButton(viewModel),
                  const SizedBox(height: 32),
                  _buildHeader(viewModel),
                  const SizedBox(height: 32),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: viewModel.step == RecoveryStep.verifyData
                        ? _buildVerifyDataForm(context, viewModel)
                        : _buildNewPasswordForm(viewModel),
                  ),
                  const SizedBox(height: 32),
                  _buildActionButton(viewModel),
                  const SizedBox(height: 24),
                  _buildLoginLink(viewModel),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackButton(ForgotPasswordViewModel viewModel) {
    return GestureDetector(
      onTap: viewModel.goBack,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE4E4E7)),
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          size: 20,
          color: Color(0xFF18181B),
        ),
      ),
    );
  }

  Widget _buildHeader(ForgotPasswordViewModel viewModel) {
    final isVerifyStep = viewModel.step == RecoveryStep.verifyData;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isVerifyStep ? 'Recuperar senha' : 'Nova senha',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF18181B),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isVerifyStep 
              ? 'Confirme seus dados para recuperar o acesso'
              : 'Defina sua nova senha de acesso',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF71717A),
          ),
        ),
      ],
    );
  }

  Widget _buildVerifyDataForm(BuildContext context, ForgotPasswordViewModel viewModel) {
    return Column(
      key: const ValueKey('verify'),
      children: [
        // Nome completo
        _InputField(
          controller: viewModel.fullNameController,
          label: 'Nome completo',
          hint: 'Mesmo usado no cadastro',
          prefixIcon: Icons.person_outline_rounded,
          error: viewModel.fullNameError,
          onChanged: (_) => viewModel.clearErrors(),
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),
        
        // Username
        _InputField(
          controller: viewModel.usernameController,
          label: 'Usuário',
          hint: 'Seu nome de usuário',
          prefixIcon: Icons.alternate_email_rounded,
          error: viewModel.usernameError,
          onChanged: (_) => viewModel.clearErrors(),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        
        // Data de nascimento - Shadcn Calendar
        ShadcnCalendar(
          viewModel: viewModel.calendarViewModel,
          label: 'Data de nascimento',
          placeholder: 'Mesma do cadastro',
          error: viewModel.birthDateError,
        ),
      ],
    );
  }

  Widget _buildNewPasswordForm(ForgotPasswordViewModel viewModel) {
    return Column(
      key: const ValueKey('password'),
      children: [
        // Nova senha
        _InputField(
          controller: viewModel.passwordController,
          label: 'Nova senha',
          hint: 'Mínimo 6 caracteres',
          prefixIcon: Icons.lock_outline_rounded,
          isPassword: true,
          isPasswordVisible: viewModel.isPasswordVisible,
          onTogglePassword: viewModel.togglePasswordVisibility,
          error: viewModel.passwordError,
          onChanged: (_) => viewModel.clearErrors(),
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: 16),
        
        // Confirmar senha
        _InputField(
          controller: viewModel.confirmPasswordController,
          label: 'Confirmar nova senha',
          hint: 'Repita a nova senha',
          prefixIcon: Icons.lock_outline_rounded,
          isPassword: true,
          isPasswordVisible: viewModel.isConfirmPasswordVisible,
          onTogglePassword: viewModel.toggleConfirmPasswordVisibility,
          error: viewModel.confirmPasswordError,
          onChanged: (_) => viewModel.clearErrors(),
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => viewModel.resetPassword(),
        ),
      ],
    );
  }

  Widget _buildActionButton(ForgotPasswordViewModel viewModel) {
    final isVerifyStep = viewModel.step == RecoveryStep.verifyData;
    
    return _PrimaryButton(
      label: isVerifyStep ? 'Verificar dados' : 'Redefinir senha',
      isLoading: viewModel.isLoading,
      onPressed: isVerifyStep ? viewModel.verifyData : viewModel.resetPassword,
    );
  }

  Widget _buildLoginLink(ForgotPasswordViewModel viewModel) {
    return Center(
      child: GestureDetector(
        onTap: viewModel.goToLogin,
        child: RichText(
          text: TextSpan(
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF71717A),
            ),
            children: [
              const TextSpan(text: 'Lembrou a senha? '),
              TextSpan(
                text: 'Entrar',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF18181B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Campo de Input customizado
class _InputField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData? prefixIcon;
  final bool isPassword;
  final bool isPasswordVisible;
  final VoidCallback? onTogglePassword;
  final String? error;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final TextCapitalization textCapitalization;

  const _InputField({
    required this.controller,
    required this.label,
    required this.hint,
    this.prefixIcon,
    this.isPassword = false,
    this.isPasswordVisible = false,
    this.onTogglePassword,
    this.error,
    this.onChanged,
    this.textInputAction,
    this.onSubmitted,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final hasError = widget.error != null;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF18181B),
          ),
        ),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: hasError
                  ? const Color(0xFFEF4444)
                  : _isFocused
                      ? const Color(0xFF18181B)
                      : const Color(0xFFE4E4E7),
              width: _isFocused || hasError ? 1.5 : 1,
            ),
          ),
          child: Focus(
            onFocusChange: (focused) => setState(() => _isFocused = focused),
            child: TextField(
              controller: widget.controller,
              obscureText: widget.isPassword && !widget.isPasswordVisible,
              onChanged: widget.onChanged,
              textInputAction: widget.textInputAction,
              onSubmitted: widget.onSubmitted,
              textCapitalization: widget.textCapitalization,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF18181B),
              ),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFFA1A1AA),
                ),
                prefixIcon: widget.prefixIcon != null
                    ? Icon(
                        widget.prefixIcon,
                        size: 20,
                        color: _isFocused 
                            ? const Color(0xFF18181B) 
                            : const Color(0xFFA1A1AA),
                      )
                    : null,
                suffixIcon: widget.isPassword
                    ? GestureDetector(
                        onTap: widget.onTogglePassword,
                        child: Icon(
                          widget.isPasswordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                          color: const Color(0xFFA1A1AA),
                        ),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ),
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
      ],
    );
  }
}

/// Botão Primário
class _PrimaryButton extends StatefulWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  const _PrimaryButton({
    required this.label,
    this.isLoading = false,
    required this.onPressed,
  });

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.isLoading ? null : widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: widget.isLoading
              ? const Color(0xFF52525B)
              : _isPressed
                  ? const Color(0xFF27272A)
                  : const Color(0xFF18181B),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: widget.isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  widget.label,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }
}
