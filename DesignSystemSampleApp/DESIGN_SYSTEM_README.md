# Design System - Arquitetura Refatorada

## 📋 Visão Geral

Este Design System foi completamente refatorado para seguir uma arquitetura baseada em **ViewModels com herança**, proporcionando maior reutilização de código, manutenibilidade e consistência.

## 🏗️ Estrutura de Diretórios

```
lib/design_system/
├── core/
│   └── base_component_view_model.dart    # ViewModels base
├── theme/
│   └── design_system_theme.dart          # Tema centralizado
├── components/
│   ├── button/
│   │   ├── button.dart                   # Widget do botão
│   │   └── button_view_model.dart        # ViewModel do botão
│   ├── input/
│   │   ├── input.dart                    # Widget do input
│   │   └── input_view_model.dart         # ViewModel do input
│   ├── linked_label/
│   │   ├── linked_label.dart             # Widget do linked label
│   │   └── linked_label_view_model.dart  # ViewModel do linked label
│   ├── tab/
│   │   ├── tab.dart                      # Widget do tab
│   │   └── tab_view_model.dart           # ViewModel do tab
│   └── bottom_navigation/
│       ├── bottom_navigation.dart        # Widget da bottom navigation
│       └── bottom_navigation_view_model.dart  # ViewModel
└── design_system.dart                    # Arquivo de exportação central
```

## 🎯 Arquitetura de ViewModels

### Hierarquia de ViewModels

```
BaseComponentViewModel (classe abstrata)
│
├── InteractiveComponentViewModel
│   ├── ButtonViewModel
│   └── InputViewModel
│
├── TextComponentViewModel
│   └── LinkedLabelViewModel
│
└── IconComponentViewModel
```

### Classes Base

#### BaseComponentViewModel
Contém propriedades comuns a todos os componentes:
- `id`: Identificador único
- `isEnabled`: Estado habilitado/desabilitado
- `padding`: Espaçamento interno
- `margin`: Espaçamento externo
- `backgroundColor`: Cor de fundo
- `width`, `height`: Dimensões
- `tooltip`: Dica de ferramenta

#### InteractiveComponentViewModel
Estende `BaseComponentViewModel` para componentes interativos:
- `onPressed`: Callback de interação
- `isLoading`: Estado de carregamento
- `autoFocus`: Foco automático

#### TextComponentViewModel
Estende `BaseComponentViewModel` para componentes com texto:
- `text`: Texto a ser exibido
- `textStyle`: Estilo do texto
- `textAlign`: Alinhamento
- `maxLines`: Número máximo de linhas
- `overflow`: Comportamento de overflow

#### IconComponentViewModel
Estende `BaseComponentViewModel` para componentes com ícone:
- `icon`: Ícone a ser exibido
- `iconSize`: Tamanho do ícone
- `iconColor`: Cor do ícone

## 🧩 Componentes Disponíveis

### 1. Button (DSButton)

**ViewModel:** `ButtonViewModel` (extends `InteractiveComponentViewModel`)

**Variantes:**
- `primary`: Botão principal
- `secondary`: Botão secundário
- `tertiary`: Botão terciário
- `outline`: Botão com borda
- `ghost`: Botão transparente
- `destructive`: Botão de ação destrutiva

**Tamanhos:**
- `small`: Pequeno
- `medium`: Médio (padrão)
- `large`: Grande

**Exemplo de uso:**
```dart
DSButton(
  viewModel: ButtonViewModel(
    text: 'Clique Aqui',
    size: ButtonSize.medium,
    variant: ButtonVariant.primary,
    icon: Icons.send,
    iconPosition: IconPosition.leading,
    onPressed: () {
      print('Botão clicado!');
    },
  ),
)
```

### 2. Input (DSInput)

**ViewModel:** `InputViewModel` (extends `InteractiveComponentViewModel`)

**Recursos:**
- Validação em tempo real
- Campos de senha com toggle de visibilidade
- Prefixo e sufixo customizáveis
- Suporte para multilinha
- Diferentes tipos de teclado

**Exemplo de uso:**
```dart
DSInput(
  viewModel: InputViewModel(
    controller: _emailController,
    placeholder: 'Email',
    keyboardType: TextInputType.emailAddress,
    validator: (value) {
      if (!value.contains('@')) return 'Email inválido';
      return null;
    },
    prefixIcon: Icon(Icons.email_outlined),
  ),
)
```

### 3. LinkedLabel (DSLinkedLabel)

**ViewModel:** `LinkedLabelViewModel` (extends `TextComponentViewModel`)

**Recursos:**
- Texto com parte clicável
- Estilo customizável para o link
- Callback de clique

**Exemplo de uso:**
```dart
DSLinkedLabel(
  viewModel: LinkedLabelViewModel(
    text: 'Não tem uma conta? Cadastre-se aqui',
    linkedText: 'Cadastre-se aqui',
    onLinkTap: () {
      // Navegar para tela de cadastro
    },
  ),
)
```

### 4. TabBar (DSTabBar)

**ViewModel:** `TabBarViewModel` (extends `BaseComponentViewModel`)

**Recursos:**
- Múltiplas tabs
- Indicador customizável
- Tabs roláveis ou fixas
- Delegate para callbacks

**Exemplo de uso:**
```dart
DSTabBar(
  viewModel: TabBarViewModel(
    tabs: [
      TabItemViewModel(text: 'Tab 1', icon: Icons.home),
      TabItemViewModel(text: 'Tab 2', icon: Icons.settings),
    ],
    initialIndex: 0,
    delegate: myTabDelegate,
  ),
)
```

### 5. BottomNavigationBar (DSBottomNavigationBar)

**ViewModel:** `BottomNavigationBarViewModel` (extends `BaseComponentViewModel`)

**Recursos:**
- Múltiplos itens
- Ícones customizáveis
- Delegate para callbacks

**Exemplo de uso:**
```dart
DSBottomNavigationBar(
  viewModel: BottomNavigationBarViewModel(
    items: [
      BottomNavigationItemViewModel(
        icon: Icons.home,
        label: 'Home',
      ),
      BottomNavigationItemViewModel(
        icon: Icons.search,
        label: 'Buscar',
      ),
    ],
    currentIndex: 0,
    delegate: myBottomNavDelegate,
  ),
)
```

## 🎨 Sistema de Temas

O `DesignSystemTheme` centraliza todas as cores e configurações de tema:

```dart
final theme = DesignSystemTheme.of(context);

// Cores disponíveis:
theme.primaryColor
theme.secondaryColor
theme.tertiaryColor
theme.errorColor
theme.successColor
theme.warningColor
theme.infoColor
// ... e muitas outras
```

## 📱 Exemplos de Uso

Todas as páginas de exemplo estão em:
```
lib/features/showcase/
├── component_showcase_page.dart      # Página principal
├── button_sample_page.dart           # Exemplos de botões
├── input_sample_page.dart            # Exemplos de inputs
└── linked_label_sample_page.dart     # Exemplos de linked labels
```

## 🚀 Como Usar

### Importação
```dart
import 'package:design_system_sample_app/design_system/design_system.dart';
```

Este único import dá acesso a todos os componentes, ViewModels e temas.

### Padrão de Uso

1. **Crie o ViewModel** com as propriedades necessárias
2. **Passe o ViewModel** para o componente
3. **O componente renderiza** baseado no ViewModel

```dart
// 1. Criar ViewModel
final buttonVM = ButtonViewModel(
  text: 'Salvar',
  variant: ButtonVariant.primary,
  onPressed: _handleSave,
);

// 2. Usar o componente
DSButton(viewModel: buttonVM)
```

## 🔄 Benefícios da Arquitetura

### 1. **Herança**
- Propriedades comuns definidas uma vez no base
- Componentes específicos apenas adicionam o necessário
- Reduz duplicação de código

### 2. **Separação de Responsabilidades**
- ViewModel: Dados e configuração
- Widget: Apenas renderização
- Fácil de testar separadamente

### 3. **Reutilização**
- ViewModels podem ser criados em qualquer lugar
- Componentes sempre renderizam de forma consistente
- Fácil criar variações usando `copyWith()`

### 4. **Manutenibilidade**
- Mudanças no base afetam todos os componentes
- Fácil adicionar novas propriedades comuns
- Código organizado e previsível

### 5. **Type Safety**
- Enums para variantes e tamanhos
- Validação em tempo de compilação
- Menos erros em runtime

## 📝 Próximos Passos

- [ ] Adicionar mais componentes (Cards, Modals, etc)
- [ ] Implementar temas customizáveis
- [ ] Adicionar animações
- [ ] Criar documentação interativa
- [ ] Testes unitários para ViewModels
- [ ] Testes de widget

## 🤝 Contribuindo

Para adicionar um novo componente:

1. Crie o ViewModel herdando da classe base apropriada
2. Implemente o Widget usando o ViewModel
3. Adicione exports em `design_system.dart`
4. Crie uma página de exemplo em `features/showcase/`

## 📄 Licença

Este projeto é parte de um Design System interno.
