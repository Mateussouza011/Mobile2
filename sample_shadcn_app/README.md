# Sample Shadcn App

Uma aplicação Flutter inspirada no design system **shadcn/ui**, demonstrando a implementação de componentes reutilizáveis com arquitetura limpa e navegação moderna.

## 🚀 Características

- **Design System**: Inspirado no shadcn/ui com paleta de cores e tipografia consistentes
- **Navegação**: Implementada com GoRouter para roteamento declarativo
- **Arquitetura**: Organizada em camadas (core, ui, features, widgets)
- **Componentes**: Botões personalizáveis com variantes, tamanhos e estados
- **Delegates**: Padrão delegate implementado para customização flexível dos componentes
- **Tema**: Suporte a tema claro e escuro

## 📁 Estrutura do Projeto

```
lib/
├── core/
│   ├── router/
│   │   └── app_router.dart          # Configuração de rotas
│   └── theme/
│       ├── colors.dart              # Paleta de cores
│       ├── typography.dart          # Configuração de tipografia
│       └── theme.dart              # Tema principal
├── features/
│   └── home/
│       └── home_page.dart          # Página inicial
├── ui/
│   └── pages/                      # Páginas da aplicação
├── widgets/
│   └── buttons/
│       └── shadcn_button.dart      # Componente de botão personalizado
└── main.dart                       # Arquivo principal
```

## 🎨 Design System

### Cores

O design system utiliza uma paleta de cores inspirada no shadcn/ui:

- **Primary**: `#18181B` - Cor principal
- **Secondary**: `#F4F4F5` - Cor secundária  
- **Background**: `#FFFFFF` - Fundo principal
- **Border**: `#E4E4E7` - Bordas e divisores
- **Destructive**: `#EF4444` - Ações destrutivas

### Tipografia

Utiliza a fonte **Inter** através do Google Fonts, com hierarquia bem definida:

- Display Large: 72px, peso 800
- Headline Large: 36px, peso 800
- Title Large: 20px, peso 600
- Body Large: 16px, peso 400
- Label Large: 14px, peso 500

## 🧩 Componentes

### ShadcnButton

Componente de botão altamente customizável que implementa o padrão delegate:

#### Variantes
- `primary` - Botão principal
- `secondary` - Botão secundário
- `outline` - Botão com borda
- `ghost` - Botão transparente
- `destructive` - Botão para ações destrutivas

#### Tamanhos
- `small` - Botão pequeno
- `medium` - Botão médio (padrão)
- `large` - Botão grande
- `icon` - Botão apenas com ícone

#### Recursos
- Estados de hover e pressed
- Loading state
- Ícones leading e trailing
- Delegate pattern para customização

#### Exemplo de uso:

```dart
ShadcnButton(
  text: 'Primary Button',
  variant: ButtonVariant.primary,
  size: ButtonSize.medium,
  leadingIcon: Icons.star,
  onPressed: () => print('Button pressed'),
)
```

## 🛠️ Padrão Delegate

O componente `ShadcnButton` implementa o padrão delegate através da interface `ButtonDelegate`, permitindo customização avançada:

```dart
class CustomButtonDelegate implements ButtonDelegate {
  @override
  Color getBackgroundColor(ButtonVariant variant, bool isHovered, bool isPressed) {
    // Implementação customizada
  }
  
  @override
  Color getForegroundColor(ButtonVariant variant) {
    // Implementação customizada
  }
  
  // Outros métodos...
}

// Uso:
ShadcnButton(
  text: 'Custom Button',
  delegate: CustomButtonDelegate(),
  onPressed: () {},
)
```

## 🚦 Navegação

A navegação é gerenciada pelo **GoRouter**, proporcionando:

- Roteamento declarativo
- Deep linking
- Tratamento de erro automático
- Navegação type-safe

```dart
// Exemplo de navegação
context.go('/profile');
context.push('/settings');
```

## 📱 Páginas

### HomePage

Página principal que demonstra todos os componentes do design system:

- Showcase dos diferentes tipos de botões
- Demonstração de variantes e tamanhos
- Exemplos de uso com ícones
- Estados de loading

## 🎯 Tecnologias Utilizadas

- **Flutter**: Framework principal
- **GoRouter**: Navegação e roteamento
- **Google Fonts**: Tipografia (Inter)
- **Material 3**: Design system base

## 🚀 Como executar

1. Certifique-se de ter o Flutter instalado
2. Clone o repositório
3. Execute `flutter pub get` para instalar as dependências
4. Execute `flutter run` para iniciar a aplicação

## 📄 Dependências

```yaml
dependencies:
  flutter:
    sdk: flutter
  go_router: ^13.2.0
  google_fonts: ^6.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

## 🤝 Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues e pull requests.

## 📝 Licença

Este projeto está sob a licença MIT.
