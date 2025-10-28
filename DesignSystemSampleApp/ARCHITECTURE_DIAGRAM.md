# Arquitetura do Design System - Diagrama Visual

## 📐 Hierarquia de ViewModels

```
                    BaseComponentViewModel
                            │
                            │ (herança)
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
        ▼                   ▼                   ▼
InteractiveComponent  TextComponent      IconComponent
    ViewModel          ViewModel          ViewModel
        │                   │
        │                   │
        ├─────┬─────┐      │
        │     │     │       │
        ▼     ▼     ▼       ▼
    Button  Input   ...  LinkedLabel
   ViewModel ViewModel    ViewModel
```

## 🔄 Fluxo de Uso de um Componente

```
1. Criar ViewModel
   ↓
   ButtonViewModel(
     text: 'Salvar',
     variant: primary,
     onPressed: callback
   )
   
2. Passar para Widget
   ↓
   DSButton(
     viewModel: buttonVM
   )
   
3. Widget Renderiza
   ↓
   - Aplica configurações do ViewModel
   - Usa tema do DesignSystemTheme
   - Renderiza UI consistente
```

## 📦 Estrutura de um Componente

```
components/button/
├── button_view_model.dart
│   └── ButtonViewModel extends InteractiveComponentViewModel
│       ├── Propriedades específicas (text, variant, size)
│       ├── Propriedades herdadas (isEnabled, onPressed, etc)
│       └── Método copyWith()
│
└── button.dart
    └── DSButton extends StatelessWidget
        ├── Recebe ButtonViewModel
        ├── Usa DesignSystemTheme
        ├── Aplica estilos baseados no ViewModel
        └── Renderiza UI
```

## 🎨 Sistema de Temas

```
DesignSystemTheme
├── Cores Primárias
│   ├── primaryColor
│   ├── secondaryColor
│   └── tertiaryColor
│
├── Cores Semânticas
│   ├── successColor
│   ├── errorColor
│   ├── warningColor
│   └── infoColor
│
├── Cores de Superfície
│   ├── backgroundColor
│   ├── surfaceColor
│   └── borderColor
│
└── Modos
    ├── Light Theme
    └── Dark Theme
```

## 🧩 Relação entre Componentes

```
App
 └── DesignSystemTheme.of(context)
      │
      ├── DSButton
      │    └── ButtonViewModel
      │
      ├── DSInput
      │    └── InputViewModel
      │
      ├── DSLinkedLabel
      │    └── LinkedLabelViewModel
      │
      ├── DSTabBar
      │    └── TabBarViewModel
      │         └── List<TabItemViewModel>
      │
      └── DSBottomNavigationBar
           └── BottomNavigationBarViewModel
                └── List<BottomNavigationItemViewModel>
```

## 🔧 Propriedades Herdadas

```
BaseComponentViewModel
│
├── id: String?
├── isEnabled: bool
├── padding: EdgeInsetsGeometry?
├── margin: EdgeInsetsGeometry?
├── backgroundColor: Color?
├── width: double?
├── height: double?
└── tooltip: String?
    │
    │ (Todos os componentes têm acesso)
    │
    ▼
ButtonViewModel / InputViewModel / LinkedLabelViewModel / etc.
```

## 📱 Exemplo de Página de Sample

```
ButtonSamplePage
├── Demonstra todas variantes
├── Demonstra todos tamanhos
├── Demonstra estados (loading, disabled)
├── Demonstra com/sem ícones
└── Código de exemplo para copiar

Layout:
┌─────────────────────────────┐
│ AppBar: "Button Samples"    │
├─────────────────────────────┤
│ Seção: "Variantes"          │
│ ├─ Primary Buttons          │
│ ├─ Secondary Buttons        │
│ ├─ Outline Buttons          │
│ └─ ...                      │
│                             │
│ Seção: "Tamanhos"           │
│ ├─ Large                    │
│ ├─ Medium                   │
│ └─ Small                    │
│                             │
│ Seção: "Estados"            │
│ ├─ Loading                  │
│ ├─ Disabled                 │
│ └─ Full Width               │
└─────────────────────────────┘
```

## 🚀 Ciclo de Vida de um Componente

```
1. Definição do ViewModel
   └── ButtonViewModel(text, variant, onPressed)

2. Criação do Widget
   └── DSButton(viewModel: buttonVM)

3. Build do Widget
   ├── Lê DesignSystemTheme
   ├── Calcula tamanhos baseado em ButtonSize
   ├── Calcula cores baseado em ButtonVariant
   └── Aplica propriedades do ViewModel

4. Renderização
   └── ElevatedButton com configurações aplicadas

5. Interação do Usuário
   └── onPressed callback do ViewModel é chamado
```

## 🎯 Padrões de Design Aplicados

```
1. ViewModel Pattern
   View ←→ ViewModel (dados e lógica)
   
2. Factory Pattern
   DSButton.instantiate(viewModel)
   
3. Delegate Pattern
   TabDelegate.onTabChanged(index)
   
4. Strategy Pattern
   Variantes de botão (primary, secondary, etc)
   
5. Builder Pattern
   ButtonViewModel com propriedades opcionais
   
6. Inheritance
   Base → Intermediate → Specific ViewModels
```

## 📊 Comparação: Antes vs Depois

### Antes da Refatoração
```
DesignSystem/
└── Components/
    ├── Buttons/
    │   └── ActionButton/
    │       ├── action_button.dart
    │       └── action_button_view_model.dart
    ├── InputField/
    │   ├── input_text.dart
    │   └── input_text_view_model.dart
    └── ... (desorganizado)

Problemas:
- ViewModels sem herança
- Duplicação de código
- Inconsistência entre componentes
- Difícil manutenção
```

### Depois da Refatoração
```
design_system/
├── core/
│   └── base_component_view_model.dart
├── theme/
│   └── design_system_theme.dart
├── components/
│   ├── button/
│   ├── input/
│   ├── linked_label/
│   ├── tab/
│   └── bottom_navigation/
└── design_system.dart (export central)

Benefícios:
✅ ViewModels com herança
✅ Código reutilizado
✅ Consistência garantida
✅ Fácil manutenção
✅ Organização clara
```

## 🎓 Como Adicionar um Novo Componente

```
1. Criar ViewModel
   └── Herdar da classe base apropriada
       └── BaseComponentViewModel ou
       └── InteractiveComponentViewModel ou
       └── TextComponentViewModel

2. Adicionar propriedades específicas
   └── Ex: variant, size, etc.

3. Implementar copyWith()
   └── Para criar cópias modificadas

4. Criar Widget
   └── Receber ViewModel no construtor
   └── Usar DesignSystemTheme
   └── Renderizar baseado no ViewModel

5. Adicionar export
   └── Em design_system.dart

6. Criar página de exemplo
   └── Em features/showcase/

7. Adicionar rota
   └── Em app_router.dart
```

Este diagrama fornece uma visão completa da arquitetura refatorada!
