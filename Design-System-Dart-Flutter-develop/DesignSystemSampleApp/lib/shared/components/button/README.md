# Button Component

Implementação completa do componente Button seguindo o design system shadcn/ui.

## 📦 Arquivos

- `button.dart` - Componente principal
- `button_view_model.dart` - ViewModel com dados imutáveis
- `button_delegate.dart` - Interface Delegate para eventos
- `button_factory.dart` - Factory para instanciação simplificada

## 🎨 Variantes

### Default (Primary)
Background primário com texto claro.
```dart
ButtonFactory.primary(
  text: 'Button',
  delegate: this,
)
```

### Destructive
Para ações destrutivas (delete, remove, etc).
```dart
ButtonFactory.destructive(
  text: 'Delete',
  delegate: this,
)
```

### Outline
Borda com background transparente.
```dart
ButtonFactory.outline(
  text: 'Button',
  delegate: this,
)
```

### Secondary
Background secundário.
```dart
ButtonFactory.secondary(
  text: 'Button',
  delegate: this,
)
```

### Ghost
Sem background, apenas texto.
```dart
ButtonFactory.ghost(
  text: 'Button',
  delegate: this,
)
```

### Link
Estilo de link com sublinhado no hover.
```dart
ButtonFactory.link(
  text: 'Button',
  delegate: this,
)
```

## 📏 Tamanhos

- **sm**: 36px altura
- **default**: 40px altura  
- **lg**: 44px altura
- **icon**: 40x40px (apenas ícone)

```dart
ButtonFactory.primary(
  text: 'Small',
  delegate: this,
  size: ButtonSize.sm,
)

ButtonFactory.primary(
  text: 'Large',
  delegate: this,
  size: ButtonSize.lg,
)
```

## 🎯 Com Ícones

### Leading Icon
```dart
ButtonFactory.withIcon(
  text: 'Email',
  icon: Icons.mail_outline,
  delegate: this,
)
```

### Trailing Icon
```dart
ButtonComponent(
  viewModel: ButtonViewModel(
    text: 'Login',
    trailingIcon: Icons.arrow_forward,
  ),
  delegate: this,
)
```

### Icon Only
```dart
ButtonFactory.icon(
  icon: Icons.favorite,
  delegate: this,
)
```

## 🔄 Estados

### Loading
```dart
ButtonFactory.loading(
  text: 'Loading...',
)
```

### Disabled
```dart
ButtonFactory.primary(
  text: 'Disabled',
  delegate: this,
  enabled: false,
)
```

## 🎁 Buttons Especializados

### Save
```dart
ButtonFactory.save(
  delegate: this,
)
```

### Delete
```dart
ButtonFactory.delete(
  delegate: this,
)
```

### Cancel
```dart
ButtonFactory.cancel(
  delegate: this,
)
```

## 📐 Full Width

```dart
ButtonFactory.primary(
  text: 'Full Width Button',
  delegate: this,
  fullWidth: true,
)
```

## 🔧 Uso Avançado com ViewModel

```dart
class MyScreen extends StatelessWidget implements ButtonDelegate {
  @override
  void onPressed() {
    print('Button clicked!');
  }

  @override
  void onLongPress() {
    print('Button long pressed!');
  }

  @override
  Widget build(BuildContext context) {
    return ButtonComponent(
      viewModel: ButtonViewModel(
        text: 'Custom Button',
        leadingIcon: Icons.star,
        trailingIcon: Icons.arrow_forward,
        variant: ButtonVariant.defaultVariant,
        size: ButtonSize.lg,
        enabled: true,
        loading: false,
        fullWidth: false,
      ),
      delegate: this,
    );
  }
}
```

## ✅ Padrões Implementados

### 1. **Delegate Pattern**
- ✅ Eventos capturados via interface `ButtonDelegate`
- ✅ NUNCA usa `Function()` ou callbacks
- ✅ Métodos: `onPressed()`, `onLongPress()`

### 2. **MVVM Pattern**
- ✅ ViewModel contém APENAS dados imutáveis
- ✅ Sem lógica de negócio no ViewModel
- ✅ Método `copyWith()` para mutabilidade controlada

### 3. **Factory Pattern**
- ✅ Métodos estáticos para instanciação
- ✅ Configurações pré-definidas (save, delete, cancel)
- ✅ Facilita criação de buttons comuns

### 4. **Clean Architecture**
- ✅ Separação de responsabilidades
- ✅ Componente isolado e reutilizável
- ✅ Fácil de testar

## 🎨 Design System (shadcn/ui)

- ✅ Paleta de cores completa (light/dark)
- ✅ Sistema de espaçamento consistente
- ✅ Tipografia Inter
- ✅ Border radius padronizado
- ✅ Animações suaves (hover, pressed)
- ✅ Estados visuais (hover, pressed, disabled, loading)

## 🧪 Testando

Execute o aplicativo e navegue até "Button Component" na tela inicial para ver todas as variantes em ação.

```bash
flutter run -d chrome
```

## 📚 Referências

- [shadcn/ui Button](https://ui.shadcn.com/docs/components/button)
- [Material Design 3](https://m3.material.io/components/buttons)
