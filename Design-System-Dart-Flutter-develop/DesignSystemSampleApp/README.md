# 🎨 Shadcn/UI Design System - Flutter

Um aplicativo de demonstração completo implementando o sistema de design **Shadcn/UI** em Flutter, com suporte total a temas claro/escuro e componentes reutilizáveis.

## ✨ Características

- 🎨 **Design System Completo**: Implementação fiel do Shadcn/UI
- 🌓 **Temas Adaptativos**: Suporte completo a light/dark mode
- 📱 **Responsivo**: Funciona perfeitamente em mobile, tablet e web
- ♿ **Acessível**: Contraste adequado e padrões WCAG
- 🧩 **Componentizado**: Componentes reutilizáveis e customizáveis
- 🌍 **Multi-idioma**: Suporte a Português, Inglês e Espanhol

## 🚀 Páginas Implementadas

### 📋 **CardsPage**
- ✅ Lista de 5 itens estilizados (ListTile)
- ✅ Cards com imagem, título, descrição e botões de ação
- ✅ Contraste adequado em ambos os temas

### 📊 **TablePage**
- ✅ Tabela com 3 colunas (Nome, Status, Ação)
- ✅ 5 linhas de dados simulados
- ✅ Botões "Ver mais" funcionais
- ✅ Status coloridos com indicadores visuais

### 🎚️ **SlidersPage**
- ✅ Slider simples (0-100)
- ✅ Slider com valores pré-definidos (0, 25, 50, 75, 100)
- ✅ Slider estilizado com label de valor atual
- ✅ Labels adaptáveis ao tema

### 🪟 **ModalsPage**
- ✅ Modal de confirmação (Confirmar/Cancelar)
- ✅ Modal informativo (texto + botão Ok)
- ✅ Contraste adequado nos modais

### ⚙️ **SettingsPage**
- ✅ Switch para alternar modo escuro/claro
- ✅ Dropdown de seleção de idioma
- ✅ Card de preview do tema atual
- ✅ Persistência de configurações

## 📦 Pré-requisitos

### 🛠️ Ferramentas Necessárias

- **Flutter SDK**: versão 3.16.0 ou superior
- **Dart SDK**: versão 3.2.0 ou superior
- **Android Studio** (para desenvolvimento Android)
- **Xcode** (para desenvolvimento iOS - apenas macOS)
- **VS Code** ou **IntelliJ IDEA** (recomendado)

### 📱 Para desenvolvimento Android
- Android SDK (API level 21 ou superior)
- Emulador Android ou dispositivo físico

### 🍎 Para desenvolvimento iOS
- macOS 10.15 ou superior
- Xcode 12.0 ou superior
- iOS Simulator ou dispositivo físico

### 🌐 Para desenvolvimento Web
- Chrome ou Edge (recomendado para debugging)

## 🔧 Instalação

### 1️⃣ Clone o repositório
```bash
git clone https://github.com/Mateussouza011/Mobile2.git
cd Mobile2/Design-System-Dart-Flutter-develop/DesignSystemSampleApp
```

### 2️⃣ Instale as dependências
```bash
flutter pub get
```

### 3️⃣ Verifique a configuração do Flutter
```bash
flutter doctor
```

### 4️⃣ Execute o aplicativo

#### 📱 Android
```bash
flutter run -d android
```

#### 🍎 iOS
```bash
flutter run -d ios
```

#### 🌐 Web
```bash
flutter run -d web-server --web-port 8080
```

#### 🖥️ Desktop (Windows/macOS/Linux)
```bash
flutter run -d windows    # Windows
flutter run -d macos      # macOS
flutter run -d linux      # Linux
```

## 🏗️ Estrutura do Projeto

```
lib/
├── 📂 core/                      # Configurações centrais
│   ├── 📂 providers/            # Gerenciamento de estado
│   │   └── theme_provider.dart  # Provider para temas
│   ├── 📂 router/               # Navegação
│   │   └── app_router.dart      # Configuração de rotas
│   └── 📂 theme/                # Sistema de temas
│       └── app_theme.dart       # Implementação Shadcn/UI
├── 📂 features/                  # Páginas da aplicação
│   ├── 📂 cards/               # Página de Cards e Listas
│   ├── 📂 tables/              # Página de Tabelas
│   ├── 📂 sliders/             # Página de Sliders
│   ├── 📂 modals/              # Página de Modais
│   ├── 📂 settings/            # Página de Configurações
│   └── 📂 home/                # Página inicial
├── 📂 ui/                       # Componentes de UI
│   └── 📂 widgets/             # Widgets reutilizáveis
│       └── 📂 shadcn/          # Componentes Shadcn/UI
│           ├── shadcn_button.dart
│           └── shadcn_card.dart
└── main.dart                    # Ponto de entrada
```

## 🎨 Design System

### 🎯 Cores Principais

#### 🌞 Tema Claro
- **Primary**: `#171717` (Neutro escuro)
- **Secondary**: `#F5F5F5` (Neutro claro)
- **Background**: `#FFFFFF` (Branco)
- **Surface**: `#FFFFFF` (Branco)
- **Error**: `#EF4444` (Vermelho)

#### 🌙 Tema Escuro
- **Primary**: `#FAFAFA` (Neutro claro)
- **Secondary**: `#262626` (Neutro escuro)
- **Background**: `#0A0A0A` (Preto)
- **Surface**: `#0A0A0A` (Preto)
- **Error**: `#7F1D1D` (Vermelho escuro)

### 🔤 Tipografia
- **Fonte**: Inter (via Google Fonts)
- **Pesos**: 400, 500, 600, 700, 800
- **Tamanhos**: 10px - 36px
- **Espaçamento**: Otimizado para legibilidade

### 🧩 Componentes
- **ShadcnButton**: Botão com variantes (default, outline, ghost)
- **ShadcnCard**: Card com bordas e elevação customizadas
- **Inputs**: Campos de entrada estilizados
- **Modais**: Dialogs com contraste adequado

## 🚀 Build e Deploy

### 📱 Android APK
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# APK será gerado em: build/app/outputs/flutter-apk/
```

### 🍎 iOS IPA
```bash
# Apenas no macOS
flutter build ios --release

# Para distribuição na App Store
flutter build ipa
```

### 🌐 Web
```bash
# Build para produção
flutter build web --release

# Arquivos gerados em: build/web/
```

### 🖥️ Desktop
```bash
# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

## 🧪 Testes

### 🏃‍♂️ Executar Testes
```bash
# Todos os testes
flutter test

# Testes com coverage
flutter test --coverage

# Testes de integração
flutter drive --target=test_driver/app.dart
```

## 🔍 Debugging

### 🐛 Debug Mode
```bash
flutter run --debug
```

### 📊 Performance Profiling
```bash
flutter run --profile
```

### 🔧 Hot Reload
Durante o desenvolvimento, use:
- **r**: Hot reload
- **R**: Hot restart
- **q**: Quit

## 📚 Dependências Principais

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # UI e Temas
  google_fonts: ^6.1.0
  
  # Navegação
  go_router: ^12.1.3
  
  # Gerenciamento de Estado
  provider: ^6.1.1
  
  # Desenvolvimento
  flutter_lints: ^3.0.0
```

## 🤝 Contribuindo

1. 🍴 Fork o projeto
2. 🌿 Crie uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. 💾 Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. 📤 Push para a branch (`git push origin feature/AmazingFeature`)
5. 🔄 Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## 👨‍💻 Autor

**Mateus Souza**
- GitHub: [@Mateussouza011](https://github.com/Mateussouza011)

## 🙏 Agradecimentos

- [Shadcn/UI](https://ui.shadcn.com/) pelo sistema de design inspirador
- [Flutter](https://flutter.dev/) pela framework incrível
- [Google Fonts](https://fonts.google.com/) pela tipografia Inter

---

⭐ **Gostou do projeto? Deixe uma estrela!** ⭐
