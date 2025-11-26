import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../DesignSystem/Theme/app_theme.dart';
import '../../../ui/widgets/shadcn/shadcn_button.dart';
import '../../../ui/widgets/shadcn/shadcn_input.dart';
import 'login_view_model.dart';

/// LoginView - Design moderno, minimalista e elegante
/// 
/// Inspirado no estilo visual shadcn/iOS com:
/// - Layout simétrico e limpo
/// - Inputs elegantes com estados visuais
/// - Micro-interações suaves
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> 
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
    
    return Scaffold(
      backgroundColor: AppColors.zinc50,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: _buildContent(context),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final viewModel = context.watch<LoginViewModel>();
    
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            
            // Back button
            _buildBackButton(context),
            
            const SizedBox(height: 40),
            
            // Header
            _buildHeader(),
            
            const SizedBox(height: 40),
            
            // Form
            _buildForm(viewModel),
            
            const SizedBox(height: 24),
            
            // Options row
            _buildOptionsRow(viewModel),
            
            const SizedBox(height: 32),
            
            // Login button
            _buildLoginButton(viewModel),
            
            const SizedBox(height: 24),
            
            // Divider
            _buildDivider(),
            
            const SizedBox(height: 24),
            
            // Social buttons
            _buildSocialButtons(),
            
            const SizedBox(height: 32),
            
            // Create account
            _buildCreateAccountLink(viewModel),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          size: 20,
          color: AppColors.zinc900,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bem-vindo de volta',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: AppColors.zinc900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Entre com sua conta para continuar',
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: AppColors.zinc500,
          ),
        ),
      ],
    );
  }

  Widget _buildForm(LoginViewModel viewModel) {
    return Column(
      children: [
        ShadcnInput.email(
          controller: viewModel.emailController,
          label: 'Email',
          placeholder: 'seu@email.com',
          errorText: viewModel.emailError,
          onChanged: (_) => viewModel.clearErrors(),
          prefixIcon: const Icon(Icons.mail_outline_rounded),
        ),
        const SizedBox(height: 16),
        ShadcnInput.password(
          controller: viewModel.passwordController,
          label: 'Senha',
          placeholder: '••••••••',
          errorText: viewModel.passwordError,
          onChanged: (_) => viewModel.clearErrors(),
          prefixIcon: const Icon(Icons.lock_outline_rounded),
        ),
      ],
    );
  }

  Widget _buildOptionsRow(LoginViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Remember me
        GestureDetector(
          onTap: viewModel.toggleRememberMe,
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: viewModel.rememberMe 
                      ? AppColors.primary 
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: viewModel.rememberMe 
                        ? AppColors.primary 
                        : AppColors.zinc300,
                  ),
                ),
                child: viewModel.rememberMe
                    ? const Icon(Icons.check, size: 14, color: AppColors.onPrimary)
                    : null,
              ),
              const SizedBox(width: 8),
              Text(
                'Lembrar-me',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.zinc600,
                ),
              ),
            ],
          ),
        ),
        
        // Forgot password
        GestureDetector(
          onTap: viewModel.forgotPassword,
          child: Text(
            'Esqueceu a senha?',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.zinc900,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton(LoginViewModel viewModel) {
    return SizedBox(
      width: double.infinity,
      child: ShadcnButton(
        text: 'Entrar',
        loading: viewModel.isLoading,
        onPressed: viewModel.login,
        size: ShadcnButtonSize.lg,
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'ou continue com',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.zinc400,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border)),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        Expanded(
          child: ShadcnButton(
            variant: ShadcnButtonVariant.outline,
            leadingIcon: const Icon(Icons.g_mobiledata_rounded, size: 22),
            text: 'Google',
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ShadcnButton(
            variant: ShadcnButtonVariant.outline,
            leadingIcon: const Icon(Icons.apple_rounded, size: 22),
            text: 'Apple',
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildCreateAccountLink(LoginViewModel viewModel) {
    return Center(
      child: GestureDetector(
        onTap: viewModel.createAccount,
        child: RichText(
          text: TextSpan(
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.zinc500,
            ),
            children: [
              const TextSpan(text: 'Não tem uma conta? '),
              TextSpan(
                text: 'Criar conta',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.zinc900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
