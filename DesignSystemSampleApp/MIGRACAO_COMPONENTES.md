# Migração de Componentes - Consolidação

## 📦 Componentes Consolidados

Todos os componentes foram movidos para a estrutura unificada em `/lib/design_system/components/`.

## 🗺️ Mapeamento de Localização

### Antes (Espalhados)
```
lib/
├── DesignSystem/Components/
│   ├── Buttons/ActionButton/
│   │   ├── action_button.dart
│   │   └── action_button_view_model.dart
│   ├── InputField/
│   │   ├── input_text.dart
│   │   └── input_text_view_model.dart
│   ├── LinkedLabel/
│   │   ├── linked_label.dart
│   │   └── linked_label_view_model.dart
│   ├── Tab/
│   ├── TabBar/
│   └── BottomTabBar/
└── widgets/
    └── buttons/
        └── custom_button.dart
```

### Depois (Consolidados)
```
lib/design_system/
├── core/
│   └── base_component_view_model.dart
├── theme/
│   └── design_system_theme.dart
├── components/
│   ├── button/
│   │   ├── button.dart (DSButton)
│   │   └── button_view_model.dart
│   ├── input/
│   │   ├── input.dart (DSInput)
│   │   └── input_view_model.dart
│   ├── linked_label/
│   │   ├── linked_label.dart (DSLinkedLabel)
│   │   └── linked_label_view_model.dart
│   ├── tab/
│   │   ├── tab.dart (DSTabBar)
│   │   └── tab_view_model.dart
│   ├── bottom_navigation/
│   │   ├── bottom_navigation.dart (DSBottomNavigationBar)
│   │   └── bottom_navigation_view_model.dart
│   └── legacy/
│       ├── action_button_legacy.dart
│       ├── input_text_legacy.dart
│       └── linked_label_legacy.dart
└── design_system.dart (export central)
```

## 🔄 Componentes Legados (Compatibilidade)

Para manter a compatibilidade com código existente, foram criados wrappers legados:

### ActionButton → DSButton
```dart
// ANTIGO (ainda funciona)
import 'package:design_system_sample_app/design_system/design_system.dart';

ActionButton.instantiate(
  viewModel: ActionButtonViewModel(
    size: ActionButtonSize.medium,
    style: ActionButtonStyle.primary,
    text: 'Clique',
    onPressed: () {},
  ),
)

// NOVO (recomendado)
DSButton(
  viewModel: ButtonViewModel(
    text: 'Clique',
    size: ButtonSize.medium,
    variant: ButtonVariant.primary,
    onPressed: () {},
  ),
)
```

### StyledInputField → DSInput
```dart
// ANTIGO (ainda funciona)
StyledInputField.instantiate(
  viewModel: InputTextViewModel(
    controller: controller,
    placeholder: 'Email',
    password: false,
  ),
)

// NOVO (recomendado)
DSInput(
  viewModel: InputViewModel(
    controller: controller,
    placeholder: 'Email',
    isPassword: false,
  ),
)
```

### LinkedLabel → DSLinkedLabel
```dart
// ANTIGO (ainda funciona via LegacyLinkedLabelViewModel)
LinkedLabel.instantiate(
  viewModel: LegacyLinkedLabelViewModel(
    fullText: 'Termos de Uso',
    linkedText: 'Uso',
    onLinkTap: () {},
  ),
)

// NOVO (recomendado)
DSLinkedLabel(
  viewModel: LinkedLabelViewModel(
    text: 'Termos de Uso',
    linkedText: 'Uso',
    onLinkTap: () {},
  ),
)
```

## 📋 Checklist de Migração

### Para Novos Componentes
- [ ] Sempre usar componentes em `lib/design_system/components/`
- [ ] Usar ViewModels com herança
- [ ] Seguir nomenclatura `DS` + Nome (DSButton, DSInput, etc.)
- [ ] Documentar uso em páginas showcase

### Para Código Existente
- ✅ Código antigo continua funcionando (via wrappers legados)
- ✅ Importar apenas de `lib/design_system/design_system.dart`
- ⚠️ Componentes legados marcados como deprecated
- 🎯 Migrar gradualmente para novos componentes

## 🎯 Benefícios da Consolidação

### 1. Organização
- ✅ Todos os componentes em um único lugar
- ✅ Estrutura previsível e consistente
- ✅ Fácil de encontrar e manter

### 2. Reutilização
- ✅ ViewModels com herança
- ✅ Propriedades comuns centralizadas
- ✅ Código não duplicado

### 3. Manutenibilidade
- ✅ Mudanças centralizadas
- ✅ Testes mais fáceis
- ✅ Documentação clara

### 4. Escalabilidade
- ✅ Padrão estabelecido
- ✅ Fácil adicionar novos componentes
- ✅ Consistência garantida

## 🚀 Próximos Passos

### Fase 1: Consolidação (✅ Concluída)
- [x] Criar estrutura unificada
- [x] Migrar componentes existentes
- [x] Criar wrappers de compatibilidade
- [x] Documentar migração

### Fase 2: Deprecação Suave
- [ ] Marcar componentes antigos como @deprecated
- [ ] Adicionar warnings de depreciação
- [ ] Atualizar código existente gradualmente

### Fase 3: Remoção (Futuro)
- [ ] Remover pasta `DesignSystem/` antiga
- [ ] Remover pasta `widgets/buttons/`
- [ ] Limpar imports legados
- [ ] Atualizar toda documentação

## 📖 Referências

### Import Principal
```dart
import 'package:design_system_sample_app/design_system/design_system.dart';
```

Este único import fornece acesso a:
- Todos os componentes novos (DS*)
- Todos os componentes legados (para compatibilidade)
- ViewModels base
- Tema do design system

### Documentação
- `/DESIGN_SYSTEM_README.md` - Guia completo
- `/ARCHITECTURE_DIAGRAM.md` - Diagramas visuais
- `/lib/features/showcase/` - Exemplos práticos

## ⚠️ Avisos Importantes

1. **Não criar novos componentes fora de `/lib/design_system/`**
2. **Não duplicar componentes em múltiplos lugares**
3. **Sempre usar a hierarquia de ViewModels**
4. **Seguir a convenção de nomenclatura DS***
5. **Documentar novos componentes no showcase**

## 🆘 Troubleshooting

### Erro: "Can't find component"
✅ Verifique se está importando de `design_system/design_system.dart`

### Erro: "ViewModel não tem propriedade X"
✅ Verifique se o ViewModel herda da classe base correta

### Componente antigo não funciona
✅ Use o wrapper legado ou migre para o novo componente

### Como migrar componente existente?
1. Crie ViewModel herdando da classe base
2. Implemente o widget usando o ViewModel
3. Adicione ao `design_system.dart`
4. Crie página de exemplo

---

**Data da Migração:** 28 de outubro de 2025
**Status:** ✅ Consolidação Completa
**Componentes Migrados:** 5 (Button, Input, LinkedLabel, Tab, BottomNavigation)
**Compatibilidade:** 100% (via wrappers legados)
