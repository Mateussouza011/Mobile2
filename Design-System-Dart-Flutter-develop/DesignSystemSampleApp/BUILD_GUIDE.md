# 🚀 Scripts de Build - Shadcn/UI Design System

Este documento contém os comandos para gerar builds das aplicações para diferentes plataformas.

## ✅ Build Web (Testado e Funcionando)

### Produção
```bash
flutter build web --release
```

**Status**: ✅ **SUCESSO** - Build gerado em `build/web/`
- Arquivos otimizados e compactados
- Tree-shaking aplicado (redução de 99% nos ícones)
- Pronto para deploy em servidor web

### Deploy Web
Para fazer deploy do build web:
1. Copie o conteúdo da pasta `build/web/` para seu servidor
2. Configure o servidor para servir arquivos estáticos
3. Certifique-se de que o servidor está configurado para SPAs (Single Page Applications)

**Exemplo de deploy com Firebase Hosting:**
```bash
firebase init hosting
firebase deploy
```

## 📱 Build Android

### Comandos de Build
```bash
# Release APK
flutter build apk --release

# Debug APK
flutter build apk --debug

# App Bundle (recomendado para Google Play Store)
flutter build appbundle --release
```

**Status**: ⚠️ **PROBLEMA DETECTADO**
- Erro de configuração do Gradle plugin loader
- Requer atualização da configuração Android
- Solução: Atualizar Flutter para versão mais recente (3.24.0+)

### Soluções para Problemas Android:
1. **Atualizar Flutter:**
   ```bash
   flutter upgrade
   flutter doctor
   ```

2. **Limpar cache:**
   ```bash
   flutter clean
   flutter pub get
   ```

3. **Aceitar licenças Android:**
   ```bash
   flutter doctor --android-licenses
   ```

## 🍎 Build iOS

### Comandos de Build
```bash
# Release iOS
flutter build ios --release

# IPA para App Store
flutter build ipa
```

**Status**: ⚠️ **REQUER macOS**
- Builds iOS só podem ser gerados em macOS
- Necessário Xcode instalado
- Certificados de desenvolvedor Apple configurados

### Configuração iOS:
1. **Abrir projeto no Xcode:**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Configurar Bundle ID e certificados**
3. **Testar em simulador ou dispositivo**

## 🖥️ Build Desktop

### Windows
```bash
flutter build windows --release
```

### macOS
```bash
flutter build macos --release
```

### Linux
```bash
flutter build linux --release
```

**Status**: ✅ **DISPONÍVEL**
- Suporte nativo do Flutter
- Builds podem ser gerados nas respectivas plataformas

## 📊 Resumo de Status dos Builds

| Plataforma | Status | Localização do Build |
|------------|--------|----------------------|
| 🌐 **Web** | ✅ Funcionando | `build/web/` |
| 📱 **Android** | ⚠️ Requer correção | `build/app/outputs/` |
| 🍎 **iOS** | ⚠️ Requer macOS | `build/ios/` |
| 🖥️ **Windows** | ✅ Disponível | `build/windows/` |
| 🖥️ **macOS** | ✅ Disponível | `build/macos/` |
| 🖥️ **Linux** | ✅ Disponível | `build/linux/` |

## 🔧 Comandos de Manutenção

### Limpar projeto
```bash
flutter clean
flutter pub get
```

### Analisar tamanho do app
```bash
flutter build apk --analyze-size
flutter build web --analyze-size
```

### Executar em diferentes plataformas
```bash
# Web
flutter run -d web-server --web-port 8080

# Android
flutter run -d android

# iOS
flutter run -d ios

# Windows
flutter run -d windows
```

## 🎯 Build de Produção Recomendado

Para uma distribuição completa, recomenda-se:

1. **Web**: ✅ Pronto para produção
2. **Android**: Corrigir configuração do Gradle primeiro
3. **iOS**: Requerer ambiente macOS
4. **Desktop**: Disponível conforme plataforma

## 📝 Notas Importantes

- O build Web está 100% funcional e otimizado
- Problemas Android são relacionados à versão do Flutter/Gradle
- Builds iOS requerem licença de desenvolvedor Apple
- Todos os builds preservam o tema Shadcn/UI e funcionalidades

---

**Para qualquer problema, consulte a documentação oficial do Flutter:** https://docs.flutter.dev/deployment