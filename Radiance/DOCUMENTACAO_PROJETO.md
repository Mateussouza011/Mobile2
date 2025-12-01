# Documentacao do Projeto Radiance

## Sumario

1. [Visao Geral](#visao-geral)
2. [O Que E Este Projeto](#o-que-e-este-projeto)
3. [Padroes de Projeto Explicados](#padroes-de-projeto-explicados)
4. [Estrutura de Pastas Detalhada](#estrutura-de-pastas-detalhada)
5. [Arquitetura Clean Architecture](#arquitetura-clean-architecture)
6. [Banco de Dados](#banco-de-dados)
7. [Integracao com API](#integracao-com-api)
8. [Sistema de Autenticacao](#sistema-de-autenticacao)
9. [Design System](#design-system)
10. [Gerenciamento de Estado](#gerenciamento-de-estado)
11. [Navegacao e Rotas](#navegacao-e-rotas)
12. [Referencia de Localizacao](#referencia-de-localizacao)

---

## Visao Geral

O Radiance e uma aplicacao Flutter multiplataforma (Android, iOS, Web) composta por:

- Design System baseado no Shadcn/UI
- Aplicacao de Predicao de Preco de Diamantes com Machine Learning
- Sistema de Autenticacao (Login, Registro, Recuperacao de Senha)

### Tecnologias

| Tecnologia | Finalidade |
|------------|------------|
| Flutter 3.x | Framework de desenvolvimento |
| Dart | Linguagem de programacao |
| SQLite (sqflite) | Banco de dados local para mobile |
| Web Storage | Armazenamento em memoria para web |
| Dio | Cliente HTTP |
| GetIt | Injecao de dependencias |
| Provider | Gerenciamento de estado |
| GoRouter | Navegacao e rotas |
| Dartz | Programacao funcional |

---

## O Que E Este Projeto

### Proposito Principal

O Radiance foi desenvolvido para resolver dois problemas:

1. **Predicao de Precos de Diamantes**: Usuarios podem inserir as caracteristicas de um diamante (peso, corte, cor, clareza, dimensoes) e o sistema utiliza um modelo de Machine Learning hospedado em uma API externa para prever o preco do diamante.

2. **Design System Reutilizavel**: O projeto inclui uma biblioteca de componentes visuais (botoes, inputs, cards, modais) baseados no Shadcn/UI, que podem ser reutilizados em outros projetos Flutter.

### Como Funciona na Pratica

```
Usuario abre o app
        |
        v
Landing Page (Tela inicial com opcoes)
        |
        +---> Login (Usuario existente)
        |           |
        |           v
        |     Dashboard (Estatisticas e acesso rapido)
        |           |
        |           +---> Nova Predicao (Formulario de diamante)
        |           |           |
        |           |           v
        |           |     API processa e retorna preco
        |           |           |
        |           |           v
        |           |     Resultado salvo no historico
        |           |
        |           +---> Ver Historico (Lista de predicoes anteriores)
        |
        +---> Registro (Novo usuario)
                    |
                    v
              Cria conta e vai para Dashboard
```

### Publico Alvo

- Joalheiros que precisam avaliar diamantes
- Comerciantes do ramo de pedras preciosas
- Desenvolvedores Flutter que querem usar o Design System

---

## Padroes de Projeto Explicados

Esta secao explica cada padrao de projeto utilizado, o motivo de sua escolha e como ele funciona na pratica.

### Clean Architecture

**O que e**: E uma forma de organizar o codigo em camadas separadas, onde cada camada tem uma responsabilidade especifica e nao conhece os detalhes de implementacao das outras.

**Por que usar**: Facilita a manutencao, permite trocar partes do sistema sem afetar outras (por exemplo, trocar o banco de dados sem mudar a interface) e torna o codigo mais testavel.

**Como funciona no Radiance**:

```
CAMADA PRESENTATION (O que o usuario ve)
|   Responsabilidade: Mostrar informacoes e capturar acoes do usuario
|   Conteudo: Widgets Flutter, telas, botoes, formularios
|   Exemplo: A tela de predicao com o formulario de diamante
|
v
CAMADA DOMAIN (Regras de negocio puras)
|   Responsabilidade: Definir O QUE o sistema faz, sem se preocupar COMO
|   Conteudo: Entidades (representacoes de dados), Use Cases (acoes do sistema)
|   Exemplo: "Um diamante tem carat, cut, color..." e "O sistema pode prever preco"
|
v
CAMADA DATA (Implementacao tecnica)
|   Responsabilidade: Implementar COMO as coisas sao feitas
|   Conteudo: Conexao com API, banco de dados, cache
|   Exemplo: "Para prever preco, faco POST para a API Railway"
|
v
CAMADA CORE (Utilitarios compartilhados)
    Responsabilidade: Fornecer ferramentas usadas por todas as camadas
    Conteudo: Cliente HTTP, injecao de dependencias, temas, constantes
    Exemplo: A classe ApiClient que todas as camadas usam para HTTP
```

### MVVM (Model-View-ViewModel)

**O que e**: Um padrao que separa a logica de apresentacao (ViewModel) da interface grafica (View) e dos dados (Model).

**Por que usar**: Permite que a interface seja atualizada automaticamente quando os dados mudam, sem precisar de codigo manual para sincronizar.

**Como funciona no Radiance**:

```dart
// MODEL - Representa os dados de um diamante
class DiamondPrediction {
  final double carat;        // Peso em quilates
  final String cut;          // Qualidade do corte (Ideal, Premium, etc)
  final double predictedPrice; // Preco previsto pela IA
}

// VIEWMODEL - Gerencia o estado e a logica
class DiamondPredictionViewModel extends ChangeNotifier {
  DiamondPrediction? _prediction;  // Dados atuais
  bool _isLoading = false;         // Esta carregando?
  String? _error;                  // Mensagem de erro, se houver

  // Quando a predicao e feita com sucesso
  void setPrediction(DiamondPrediction prediction) {
    _prediction = prediction;
    _isLoading = false;
    notifyListeners();  // Avisa a View que algo mudou
  }
}

// VIEW - A interface que o usuario ve
class PredictionView extends StatelessWidget {
  Widget build(BuildContext context) {
    return Consumer<DiamondPredictionViewModel>(
      builder: (context, viewModel, child) {
        // A View se reconstroi automaticamente quando notifyListeners() e chamado
        if (viewModel.isLoading) return CircularProgressIndicator();
        if (viewModel.prediction != null) return Text('Preco: ${viewModel.prediction.predictedPrice}');
        return PredictionForm();
      },
    );
  }
}
```

### Delegate Pattern

**O que e**: Um padrao onde uma classe delega (passa) responsabilidades para outra classe atraves de uma interface.

**Por que usar**: Desacopla a View da logica de negocio. A View nao sabe COMO as coisas sao feitas, apenas QUEM fazer.

**Como funciona no Radiance**:

```dart
// INTERFACE (Contrato) - Define O QUE pode ser feito
abstract class HomeDelegate {
  Future<void> loadStats();        // Carregar estatisticas
  void navigateToPrediction();     // Ir para tela de predicao
  Future<void> logout();           // Sair do sistema
}

// SERVICE (Implementacao) - Define COMO fazer
class HomeService implements HomeDelegate {
  final HomeViewModel viewModel;
  final BuildContext context;

  @override
  Future<void> loadStats() async {
    // Busca dados do banco/API e atualiza o ViewModel
    final stats = await repository.getStats();
    viewModel.setStats(stats);
  }

  @override
  void navigateToPrediction() {
    // Usa GoRouter para navegar
    context.go('/diamond-prediction');
  }

  @override
  Future<void> logout() async {
    // Limpa dados e redireciona para login
    await authRepository.logout();
    context.go('/diamond-login');
  }
}

// VIEW - Nao sabe como as coisas sao feitas, so pede para o delegate
class HomeView extends StatelessWidget {
  final HomeDelegate delegate;  // Recebe alguem que sabe fazer as coisas

  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => delegate.logout(),  // Pede para o delegate fazer
      child: Text('Sair'),
    );
  }
}
```

### Factory Pattern

**O que e**: Um padrao que centraliza a criacao de objetos complexos em um unico lugar.

**Por que usar**: Evita que a View precise saber como criar todas as suas dependencias. Facilita mudancas futuras.

**Como funciona no Radiance**:

```dart
class HomeFactory {
  // Metodo estatico que cria tudo que a HomeView precisa
  static Widget create(BuildContext context) {
    // 1. Cria o ViewModel (gerencia estado)
    final viewModel = HomeViewModel();

    // 2. Cria o Service (implementa a logica) passando o ViewModel
    final service = HomeService(
      viewModel: viewModel,
      context: context,
      authRepository: getIt<AuthRepository>(),  // Busca do container de DI
    );

    // 3. Retorna a View ja configurada
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: HomeView(delegate: service),
    );
  }
}

// Uso no Router - simples e limpo
GoRoute(
  path: '/diamond-home',
  builder: (context, state) => HomeFactory.create(context),
)
```

### Repository Pattern

**O que e**: Um padrao que abstrai o acesso a dados. O resto do sistema nao sabe se os dados vem de uma API, banco local ou cache.

**Por que usar**: Permite trocar a fonte de dados sem afetar o resto do codigo. Facilita testes com dados falsos.

**Como funciona no Radiance**:

```dart
// INTERFACE - Define O QUE o repositorio faz (sem dizer COMO)
abstract class PredictionRepository {
  Future<Either<Failure, DiamondPrediction>> getPrediction({
    required double carat,
    required String cut,
    // ... outros parametros
  });

  Future<Either<Failure, List<DiamondPrediction>>> getHistory();
}

// IMPLEMENTACAO - Define COMO fazer
class PredictionRepositoryImpl implements PredictionRepository {
  final PredictionRemoteDataSource remoteDataSource;  // Acesso a API
  final PredictionLocalDataSource localDataSource;    // Acesso ao banco
  final NetworkInfo networkInfo;                       // Verifica internet

  @override
  Future<Either<Failure, DiamondPrediction>> getPrediction({
    required double carat,
    required String cut,
  }) async {
    // Verifica se tem internet
    if (await networkInfo.isConnected) {
      try {
        // Busca da API
        final result = await remoteDataSource.getPrediction(carat: carat, cut: cut);
        // Salva no banco local para historico
        await localDataSource.savePrediction(result);
        // Retorna sucesso (Right = lado direito = sucesso no Either)
        return Right(result.toEntity());
      } catch (e) {
        return Left(ServerFailure('Erro ao conectar com servidor'));
      }
    } else {
      return Left(ConnectionFailure('Sem conexao com internet'));
    }
  }
}
```

### Dependency Injection (Injecao de Dependencias)

**O que e**: Uma tecnica onde as dependencias de uma classe sao fornecidas de fora, em vez de serem criadas dentro da classe.

**Por que usar**: Facilita testes (pode passar dependencias falsas), reduz acoplamento e centraliza a criacao de objetos.

**Como funciona no Radiance**:

```dart
// Container global de dependencias
final getIt = GetIt.instance;

// Configuracao feita uma vez, no inicio do app
Future<void> setupDependencyInjection() async {
  // Registra o cliente HTTP (uma unica instancia para todo o app)
  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(baseUrl: 'https://web-production-94f5d.up.railway.app'),
  );

  // Registra o DataSource remoto (depende do ApiClient)
  getIt.registerLazySingleton<PredictionRemoteDataSource>(
    () => PredictionRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  // Registra o Repository (depende dos DataSources)
  getIt.registerLazySingleton<PredictionRepository>(
    () => PredictionRepositoryImpl(
      remoteDataSource: getIt<PredictionRemoteDataSource>(),
      localDataSource: getIt<PredictionLocalDataSource>(),
      networkInfo: getIt<NetworkInfo>(),
    ),
  );
}

// Uso em qualquer lugar do app
class SomeService {
  void doSomething() {
    // Pega o repository do container - nao precisa saber como foi criado
    final repository = getIt<PredictionRepository>();
    repository.getPrediction(carat: 1.5, cut: 'Ideal');
  }
}
```

### Repository Pattern

```dart
abstract class PredictionRepository {
  Future<Either<Failure, DiamondPrediction>> getPrediction({
    required double carat,
    required String cut,
  });
}

class PredictionRepositoryImpl implements PredictionRepository {
  final PredictionRemoteDataSource remoteDataSource;
  final PredictionLocalDataSource localDataSource;
  
  @override
  Future<Either<Failure, DiamondPrediction>> getPrediction({
    required double carat,
    required String cut,
  }) async {
    if (await networkInfo.isConnected) {
      final result = await remoteDataSource.getPrediction(carat: carat, cut: cut);
      return Right(result.toEntity());
    }
    return Left(ConnectionFailure());
  }
}
```

### Dependency Injection

```dart
final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  getIt.registerLazySingleton<ApiClient>(() => ApiClient(baseUrl: ApiEndpoints.baseUrl));
  getIt.registerLazySingleton<PredictionRepository>(() => PredictionRepositoryImpl(
    remoteDataSource: getIt(),
    localDataSource: getIt(),
    networkInfo: getIt(),
  ));
}
```

---

## Estrutura de Pastas Detalhada

Esta secao explica para que serve cada pasta e arquivo do projeto.

```
lib/
  main.dart                          <- PONTO DE ENTRADA DO APP
  |                                     Aqui o Flutter inicia a execucao
  |                                     Configura providers, tema e rotas
  |
  core/                              <- NUCLEO COMPARTILHADO
  |   Contem codigo usado por todo o app
  |   Nao depende de nenhuma feature especifica
  |
  +-- base/                          <- Classes base abstratas
  |     Interfaces e classes que outras herdam
  |
  +-- constants/                     <- Valores fixos
  |     Strings, numeros, URLs que nao mudam
  |
  +-- data/                          <- Dados do core
  |   +-- database/
  |   |     local_database.dart      <- Conexao SQLite (mobile)
  |   |     web_storage.dart         <- Armazenamento em memoria (web)
  |   |
  |   +-- models/
  |   |     user_model.dart          <- Modelo de usuario com toJson/fromJson
  |   |
  |   +-- repositories/
  |   |     auth_repository.dart     <- Login, registro, logout
  |   |
  |   +-- services/
  |         Servicos compartilhados
  |
  +-- di/                            <- INJECAO DE DEPENDENCIAS
  |     dependency_injection.dart    <- Configura GetIt com todas as dependencias
  |
  +-- errors/                        <- TRATAMENTO DE ERROS
  |     exceptions.dart              <- Erros tecnicos (servidor caiu, sem internet)
  |     failures.dart                <- Erros de negocio (dados invalidos)
  |
  +-- network/                       <- COMUNICACAO COM INTERNET
  |     api_client.dart              <- Cliente HTTP com Dio (faz requisicoes)
  |     network_info.dart            <- Verifica se tem conexao
  |
  +-- providers/                     <- PROVIDERS GLOBAIS
  |     theme_provider.dart          <- Controla tema claro/escuro
  |
  +-- router/                        <- NAVEGACAO
  |     app_router.dart              <- Define todas as rotas do app
  |
  +-- theme/                         <- APARENCIA VISUAL
        app_theme.dart               <- Configuracao do ThemeData
        colors.dart                  <- Paleta de cores
        typography.dart              <- Estilos de texto

  data/                              <- CAMADA DE DADOS
  |   Implementacoes concretas de acesso a dados
  |
  +-- datasources/
  |   +-- local/
  |   |     database_helper.dart     <- Operacoes no SQLite
  |   |     prediction_local_datasource.dart <- Salva/busca predicoes locais
  |   |
  |   +-- remote/
  |         api_endpoints.dart       <- URLs da API
  |         prediction_remote_datasource.dart <- Chama API de predicao
  |
  +-- models/
  |     diamond_prediction_model.dart <- Modelo com conversao JSON
  |
  +-- repositories/
        prediction_repository_impl.dart <- Implementacao do Repository

  domain/                            <- CAMADA DE DOMINIO
  |   Regras de negocio puras, sem dependencia de frameworks
  |
  +-- entities/
  |     diamond_prediction.dart      <- Entidade pura (so dados, sem logica de API)
  |
  +-- repositories/
  |     prediction_repository.dart   <- Interface (contrato) do Repository
  |
  +-- usecases/
        get_prediction.dart          <- Caso de uso: fazer predicao
        save_prediction.dart         <- Caso de uso: salvar no historico
        get_prediction_history.dart  <- Caso de uso: buscar historico

  presentation/                      <- CAMADA DE APRESENTACAO
  |   ViewModels e Views genericas
  |
  +-- viewmodels/
  |     diamond_prediction_viewmodel.dart <- Gerencia estado da predicao
  |
  +-- views/
        diamond_prediction_view.dart <- Tela de predicao

  features/                          <- FUNCIONALIDADES (MODULOS)
  |   Cada pasta e um modulo independente do app
  |
  +-- auth/                          <- AUTENTICACAO
  |   +-- login/
  |   |     login_delegate.dart      <- Interface do que o login faz
  |   |     login_factory.dart       <- Cria LoginView com dependencias
  |   |     login_service.dart       <- Implementa logica de login
  |   |     login_view.dart          <- Tela de login
  |   |     login_view_model.dart    <- Estado do login
  |   |
  |   +-- register/                  <- Mesmo padrao para registro
  |   +-- forgot_password/           <- Mesmo padrao para recuperar senha
  |
  +-- diamond_prediction/            <- PREDICAO DE DIAMANTES
  |   +-- landing/                   <- Pagina inicial (antes do login)
  |   +-- home/                      <- Dashboard apos login
  |   +-- prediction/                <- Formulario de predicao
  |   +-- history/                   <- Historico de predicoes
  |
  +-- home/                          <- Home do Design System
  +-- buttons/                       <- Showcase de botoes
  +-- inputs/                        <- Showcase de inputs
  +-- cards/                         <- Showcase de cards
  +-- modals/                        <- Showcase de modais
  +-- sliders/                       <- Showcase de sliders
  +-- tables/                        <- Showcase de tabelas
  +-- tooltips/                      <- Showcase de tooltips
  +-- navigation/                    <- Showcase de navegacao
  +-- badges/                        <- Showcase de badges
  +-- forms/                         <- Showcase de formularios
  +-- showcase/                      <- Pagina geral do Design System

  ui/                                <- COMPONENTES DE UI
  +-- pages/                         <- Paginas reutilizaveis
  +-- widgets/
      +-- shadcn/                    <- COMPONENTES SHADCN
            shadcn_button.dart       <- Botao estilizado
            shadcn_input.dart        <- Campo de texto
            shadcn_card.dart         <- Card/Container
            shadcn_select.dart       <- Dropdown de selecao
            shadcn_slider.dart       <- Controle deslizante

  widgets/                           <- Widgets reutilizaveis gerais

  DesignSystem/                      <- DESIGN SYSTEM LEGADO
  +-- Components/                    <- Componentes antigos
  +-- Samples/                       <- Exemplos de uso
  +-- Theme/                         <- Tema do Design System
  +-- shared/                        <- Codigo compartilhado
```

### O Que Cada Tipo de Arquivo Faz

| Sufixo | Proposito | Exemplo |
|--------|-----------|---------|
| `_view.dart` | Interface grafica (tela) | `login_view.dart` - Tela de login |
| `_view_model.dart` | Gerencia estado da view | `login_view_model.dart` - Estado do login |
| `_service.dart` | Implementa logica de negocio | `login_service.dart` - Faz login |
| `_delegate.dart` | Interface/contrato | `login_delegate.dart` - Define acoes |
| `_factory.dart` | Cria objetos | `login_factory.dart` - Monta a tela |
| `_repository.dart` | Acesso a dados | `prediction_repository.dart` - Busca dados |
| `_datasource.dart` | Fonte de dados especifica | `prediction_remote_datasource.dart` - API |
| `_model.dart` | Modelo com JSON | `diamond_prediction_model.dart` |
| `_entity.dart` | Entidade pura | `diamond_prediction.dart` |

---

## Arquitetura Clean Architecture

### O Que E Clean Architecture

Clean Architecture e uma forma de organizar codigo criada por Robert C. Martin (Uncle Bob). A ideia principal e que o codigo de negocio (regras do sistema) nao deve depender de detalhes tecnicos (banco de dados, API, framework).

### Por Que Usar

1. **Testabilidade**: Cada camada pode ser testada isoladamente
2. **Manutencao**: Mudancas em uma camada nao afetam outras
3. **Flexibilidade**: Pode trocar banco de dados sem mudar regras de negocio
4. **Clareza**: Cada arquivo tem uma responsabilidade clara

### Fluxo de Dados Explicado

```
1. Usuario clica em "Prever Preco"
           |
           v
2. View captura o clique e chama ViewModel.predict()
           |
           v
3. ViewModel chama UseCase.execute() passando os dados do diamante
           |
           v
4. UseCase valida os dados e chama Repository.getPrediction()
           |
           v
5. Repository decide: tem internet? Chama API. Nao tem? Busca cache.
           |
           v
6. DataSource faz a operacao tecnica (HTTP request ou query SQL)
           |
           v
7. Resposta volta pelo mesmo caminho, transformando dados:
   API Response -> Model -> Entity -> ViewModel -> View
           |
           v
8. View mostra o preco previsto para o usuario
```

### Camada Domain Explicada

A camada Domain e o coracao do sistema. Ela contem:

**Entities (Entidades)**: Representam conceitos do negocio

```dart
// Uma entidade e uma classe simples que representa um conceito real
// Nao tem logica de API, banco ou framework - so dados puros
class DiamondPrediction extends Equatable {
  final double carat;          // Peso em quilates (ex: 1.5)
  final String cut;            // Qualidade do corte: Ideal, Premium, Very Good, Good, Fair
  final String color;          // Cor: D (melhor) ate J (pior)
  final String clarity;        // Clareza: IF, VVS1, VVS2, VS1, VS2, SI1, SI2, I1
  final double depth;          // Profundidade em % (ex: 61.5)
  final double table;          // Largura da mesa em % (ex: 57.0)
  final double x;              // Comprimento em mm
  final double y;              // Largura em mm
  final double z;              // Profundidade em mm
  final double predictedPrice; // Preco previsto pelo modelo de ML
  final DateTime timestamp;    // Quando foi feita a predicao

  // Equatable permite comparar dois diamantes facilmente
  @override
  List<Object> get props => [carat, cut, color, clarity, depth, table, x, y, z];
}
```

**Use Cases (Casos de Uso)**: Representam acoes que o usuario pode fazer

```dart
// Um Use Case representa UMA acao do sistema
// Ele orquestra a logica mas nao sabe detalhes tecnicos
class GetPredictionUseCase {
  final PredictionRepository repository;

  GetPredictionUseCase(this.repository);

  // O metodo call() permite usar a classe como funcao: useCase(params)
  Future<Either<Failure, DiamondPrediction>> call(PredictionParams params) async {
    // 1. Valida os dados de entrada
    if (params.carat <= 0) {
      return Left(ValidationFailure('Carat deve ser maior que zero'));
    }
    if (params.carat > 10) {
      return Left(ValidationFailure('Carat muito alto, verifique o valor'));
    }

    // 2. Se validou, pede para o Repository buscar a predicao
    return await repository.getPrediction(
      carat: params.carat,
      cut: params.cut,
      color: params.color,
      clarity: params.clarity,
      depth: params.depth,
      table: params.table,
      x: params.x,
      y: params.y,
      z: params.z,
    );
  }
}

// Parametros agrupados em uma classe para facilitar
class PredictionParams {
  final double carat;
  final String cut;
  final String color;
  final String clarity;
  final double depth;
  final double table;
  final double x;
  final double y;
  final double z;

  PredictionParams({
    required this.carat,
    required this.cut,
    required this.color,
    required this.clarity,
    required this.depth,
    required this.table,
    required this.x,
    required this.y,
    required this.z,
  });
}
```

### Camada Data Explicada

A camada Data implementa os detalhes tecnicos:

**Models**: Extensao das Entities com capacidade de conversao JSON

```dart
// Model estende Entity e adiciona conversao JSON
// Usado para comunicacao com API e banco de dados
class DiamondPredictionModel extends DiamondPrediction {
  DiamondPredictionModel({
    required super.carat,
    required super.cut,
    required super.color,
    required super.clarity,
    required super.depth,
    required super.table,
    required super.x,
    required super.y,
    required super.z,
    required super.predictedPrice,
    required super.timestamp,
  });

  // Cria Model a partir do JSON da API
  factory DiamondPredictionModel.fromApiResponse(Map<String, dynamic> json) {
    return DiamondPredictionModel(
      carat: (json['carat'] as num).toDouble(),
      cut: json['cut'] as String,
      color: json['color'] as String,
      clarity: json['clarity'] as String,
      depth: (json['depth'] as num).toDouble(),
      table: (json['table'] as num).toDouble(),
      x: (json['x'] as num).toDouble(),
      y: (json['y'] as num).toDouble(),
      z: (json['z'] as num).toDouble(),
      predictedPrice: (json['predicted_price'] as num).toDouble(),
      timestamp: DateTime.now(),
    );
  }

  // Converte para JSON (para salvar no banco)
  Map<String, dynamic> toJson() {
    return {
      'carat': carat,
      'cut': cut,
      'color': color,
      'clarity': clarity,
      'depth': depth,
      'table_value': table,
      'x': x,
      'y': y,
      'z': z,
      'predicted_price': predictedPrice,
      'created_at': timestamp.toIso8601String(),
    };
  }

  // Converte Model para Entity (para usar na camada Domain)
  DiamondPrediction toEntity() {
    return DiamondPrediction(
      carat: carat,
      cut: cut,
      color: color,
      clarity: clarity,
      depth: depth,
      table: table,
      x: x,
      y: y,
      z: z,
      predictedPrice: predictedPrice,
      timestamp: timestamp,
    );
  }
}
```

**DataSources**: Classes que fazem operacoes tecnicas especificas

```dart
// Remote DataSource - comunica com a API
class PredictionRemoteDataSourceImpl implements PredictionRemoteDataSource {
  final ApiClient apiClient;

  PredictionRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<DiamondPredictionModel> getPrediction({
    required double carat,
    required String cut,
    required String color,
    required String clarity,
    required double depth,
    required double table,
    required double x,
    required double y,
    required double z,
  }) async {
    // Monta o corpo da requisicao
    final requestBody = {
      'carat': carat,
      'cut': cut,
      'color': color,
      'clarity': clarity,
      'depth': depth,
      'table': table,
      'x': x,
      'y': y,
      'z': z,
    };

    // Faz POST para a API
    final response = await apiClient.post('/predict', data: requestBody);

    // Converte resposta para Model
    return DiamondPredictionModel.fromApiResponse({
      ...requestBody,
      'predicted_price': response.data['predicted_price'],
    });
  }
}

// Local DataSource - opera no banco de dados
class PredictionLocalDataSourceImpl implements PredictionLocalDataSource {
  final LocalDatabase database;

  PredictionLocalDataSourceImpl({required this.database});

  @override
  Future<void> savePrediction(DiamondPredictionModel prediction) async {
    final db = await database.database;
    await db.insert('prediction_history', prediction.toJson());
  }

  @override
  Future<List<DiamondPredictionModel>> getHistory(int userId) async {
    final db = await database.database;
    final results = await db.query(
      'prediction_history',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
    return results.map((json) => DiamondPredictionModel.fromJson(json)).toList();
  }
}
```

### Camada Data

Models:

```dart
class DiamondPredictionModel extends DiamondPrediction {
  factory DiamondPredictionModel.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
  DiamondPrediction toEntity();
}
```

DataSources:

```dart
class PredictionRemoteDataSourceImpl implements PredictionRemoteDataSource {
  final ApiClient apiClient;

  PredictionRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<DiamondPredictionModel> getPrediction({
    required double carat,
    required String cut,
    required String color,
    required String clarity,
    required double depth,
    required double table,
    required double x,
    required double y,
    required double z,
  }) async {
    final response = await apiClient.post('/predict', data: {
      'carat': carat,
      'cut': cut,
      'color': color,
      'clarity': clarity,
      'depth': depth,
      'table': table,
      'x': x,
      'y': y,
      'z': z,
    });
    return DiamondPredictionModel.fromApiResponse(response.data);
  }
}
```

---

## Banco de Dados

### O Que E o Banco de Dados Neste Projeto

O Radiance usa dois tipos de armazenamento dependendo da plataforma:

- **Mobile (Android/iOS)**: SQLite, um banco de dados relacional que fica salvo no dispositivo
- **Web**: Armazenamento em memoria (dados perdidos ao fechar o navegador)

### Por Que Dois Tipos de Banco

O SQLite usa bibliotecas nativas do sistema operacional que nao funcionam no navegador. Por isso, para web, usamos armazenamento em memoria como alternativa.

### SQLite (Mobile) Explicado

Localizacao: `lib/core/data/database/local_database.dart`

**O que e SQLite**: E um banco de dados que fica em um arquivo no celular. Nao precisa de servidor, tudo roda localmente.

**Schema (Estrutura das Tabelas)**:

```sql
-- TABELA DE USUARIOS
-- Armazena informacoes de quem tem conta no app
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,  -- Numero unico, gerado automaticamente
  name TEXT NOT NULL,                     -- Nome do usuario (obrigatorio)
  email TEXT UNIQUE NOT NULL,             -- Email unico (nao pode repetir)
  password_hash TEXT NOT NULL,            -- Senha criptografada (nunca a senha real)
  created_at TEXT NOT NULL,               -- Data de criacao da conta
  updated_at TEXT                         -- Ultima atualizacao (opcional)
);

-- TABELA DE HISTORICO DE PREDICOES
-- Guarda todas as predicoes que o usuario fez
CREATE TABLE prediction_history (
  id INTEGER PRIMARY KEY AUTOINCREMENT,   -- ID unico da predicao
  user_id INTEGER NOT NULL,               -- Qual usuario fez (referencia users.id)
  carat REAL NOT NULL,                    -- Peso do diamante em quilates
  cut TEXT NOT NULL,                      -- Qualidade do corte
  color TEXT NOT NULL,                    -- Cor do diamante
  clarity TEXT NOT NULL,                  -- Clareza do diamante
  depth REAL NOT NULL,                    -- Profundidade em %
  table_value REAL NOT NULL,              -- Largura da mesa em %
  x REAL NOT NULL,                        -- Comprimento em mm
  y REAL NOT NULL,                        -- Largura em mm
  z REAL NOT NULL,                        -- Altura em mm
  predicted_price REAL NOT NULL,          -- Preco que a IA preveu
  created_at TEXT NOT NULL,               -- Quando foi feita a predicao
  
  -- Chave estrangeira: se deletar usuario, deleta predicoes dele
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- INDICES para buscas mais rapidas
CREATE INDEX idx_prediction_user_id ON prediction_history(user_id);
CREATE INDEX idx_prediction_created_at ON prediction_history(created_at DESC);
CREATE UNIQUE INDEX idx_users_email ON users(email);
```

**Como Usar na Pratica**:

```dart
// Obter conexao com o banco
final db = await LocalDatabase.instance.database;

// INSERIR um novo usuario
await db.insert('users', {
  'name': 'Maria Silva',
  'email': 'maria@email.com',
  'password_hash': 'abc123hash...',
  'created_at': DateTime.now().toIso8601String(),
});

// BUSCAR predicoes de um usuario
final predicoes = await db.query(
  'prediction_history',           // Nome da tabela
  where: 'user_id = ?',           // Filtro: WHERE user_id = X
  whereArgs: [1],                 // Valor do filtro (user_id = 1)
  orderBy: 'created_at DESC',     // Ordenar por data decrescente
  limit: 10,                      // Pegar apenas 10 resultados
);

// ATUALIZAR dados
await db.update(
  'users',
  {'name': 'Maria Santos'},       // Novos valores
  where: 'id = ?',
  whereArgs: [1],
);

// DELETAR
await db.delete(
  'prediction_history',
  where: 'id = ?',
  whereArgs: [5],
);
```

### Web Storage Explicado

Localizacao: `lib/core/data/database/web_storage.dart`

**O que e**: Armazenamento em memoria RAM. Funciona enquanto o navegador esta aberto, mas perde tudo ao fechar.

**Por que usar**: SQLite nao funciona em navegadores. Para testes e demos, memoria e suficiente.

```dart
class WebStorage {
  // Singleton: garante que so existe uma instancia
  static final WebStorage instance = WebStorage._internal();
  WebStorage._internal();
  
  // "Tabelas" sao apenas listas em memoria
  final List<UserModel> _users = [];
  final List<PredictionHistoryModel> _predictions = [];
  
  // Usuario atualmente logado
  UserModel? _currentUser;
  
  // Contador para gerar IDs
  int _userIdCounter = 1;
  int _predictionIdCounter = 1;

  // REGISTRAR novo usuario
  Future<UserModel> registerUser({
    required String name,
    required String email,
    required String passwordHash,
  }) async {
    // Verifica se email ja existe
    if (_users.any((u) => u.email == email)) {
      throw Exception('Email ja cadastrado');
    }
    
    // Cria novo usuario
    final newUser = UserModel(
      id: _userIdCounter++,
      name: name,
      email: email,
      passwordHash: passwordHash,
      createdAt: DateTime.now(),
    );
    
    _users.add(newUser);
    return newUser;
  }

  // FAZER LOGIN
  Future<UserModel?> login(String email, String passwordHash) async {
    // Busca usuario pelo email
    final user = _users.where((u) => u.email == email).firstOrNull;
    
    // Verifica se existe e se senha confere
    if (user != null && user.passwordHash == passwordHash) {
      _currentUser = user;
      return user;
    }
    
    return null; // Login falhou
  }

  // SALVAR predicao
  Future<void> savePrediction(PredictionHistoryModel prediction) async {
    _predictions.add(prediction.copyWith(id: _predictionIdCounter++));
  }

  // BUSCAR historico do usuario logado
  Future<List<PredictionHistoryModel>> getHistory() async {
    if (_currentUser == null) return [];
    
    return _predictions
      .where((p) => p.userId == _currentUser!.id)
      .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // Mais recente primeiro
  }

  // LOGOUT
  Future<void> logout() async {
    _currentUser = null;
  }
}
```

### Selecao Automatica de Storage

O app detecta automaticamente se esta rodando na web ou mobile:

```dart
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> initializeStorage() async {
  if (kIsWeb) {
    // Web: usa armazenamento em memoria
    // Cria dados de teste para demonstracao
    await WebStorage.instance.seedTestData();
  } else {
    // Mobile: usa SQLite
    // Cria/abre o arquivo do banco de dados
    await LocalDatabase.instance.database;
  }
}

// Dados de teste para web (usuario demo)
Future<void> seedTestData() async {
  await registerUser(
    name: 'Usuario Teste',
    email: 'teste@teste.com',
    passwordHash: _hashPassword('123456'),
  );
}
```

---

## Integracao com API

### O Que E a API

A API (Application Programming Interface) e um servidor externo que recebe os dados do diamante e retorna o preco previsto. Ela usa um modelo de Machine Learning treinado com milhares de diamantes reais.

### Onde a API Esta Hospedada

A API esta hospedada no Railway, uma plataforma de cloud:
- URL: `https://web-production-94f5d.up.railway.app`
- Endpoint de predicao: `/predict`

### Cliente HTTP Explicado

Localizacao: `lib/core/network/api_client.dart`

O Cliente HTTP e responsavel por fazer requisicoes para a API:

```dart
class ApiClient {
  late final Dio _dio;  // Dio e uma biblioteca que facilita requisicoes HTTP

  ApiClient({
    required String baseUrl,
    int connectTimeout = 30000,    // 30 segundos para conectar
    int receiveTimeout = 30000,    // 30 segundos para receber resposta
  }) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,  // URL base para todas as requisicoes
      connectTimeout: Duration(milliseconds: connectTimeout),
      receiveTimeout: Duration(milliseconds: receiveTimeout),
      headers: {
        'Content-Type': 'application/json',  // Enviar dados em JSON
        'Accept': 'application/json',         // Esperar resposta em JSON
      },
    ));
    
    // Interceptors: "observadores" que veem todas as requisicoes
    _dio.interceptors.add(_LogInterceptor(_logger));   // Imprime logs
    _dio.interceptors.add(_ErrorInterceptor());        // Trata erros
  }

  // GET: buscar dados (sem enviar corpo)
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    return await _dio.get(path, queryParameters: queryParameters);
  }

  // POST: enviar dados (com corpo)
  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }

  // PUT: atualizar dados existentes
  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }

  // DELETE: remover dados
  Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }
}
```

### Endpoints (URLs da API)

Localizacao: `lib/data/datasources/remote/api_endpoints.dart`

```dart
class ApiEndpoints {
  // URL base do servidor
  static const String baseUrl = 'https://web-production-94f5d.up.railway.app';
  
  // Endpoint para fazer predicao de preco
  static const String predict = '/predict';
  
  // Endpoint para verificar se API esta funcionando
  static const String health = '/';
}
```

### Formato da Requisicao de Predicao

**O que o app envia para a API**:

```json
POST https://web-production-94f5d.up.railway.app/predict
Content-Type: application/json

{
  "carat": 1.5,        // Peso em quilates
  "cut": "Ideal",      // Corte: Fair, Good, Very Good, Premium, Ideal
  "color": "D",        // Cor: D (melhor), E, F, G, H, I, J (pior)
  "clarity": "IF",     // Clareza: IF, VVS1, VVS2, VS1, VS2, SI1, SI2, I1
  "depth": 61.5,       // Profundidade: altura / media(x,y) * 100
  "table": 57.0,       // Mesa: largura da parte superior / media(x,y) * 100
  "x": 7.2,            // Comprimento em mm
  "y": 7.15,           // Largura em mm
  "z": 4.45            // Altura em mm
}
```

**O que a API responde**:

```json
{
  "predicted_price": 15432.50    // Preco em dolares
}
```

### Tratamento de Erros Explicado

O sistema tem dois tipos de erros:

**Exceptions (Erros Tecnicos)**: Problemas de infraestrutura

```dart
// Erro do servidor (500, 502, etc)
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  
  ServerException(this.message, [this.statusCode]);
  
  @override
  String toString() => 'ServerException: $message (status: $statusCode)';
}

// Sem conexao com internet
class ConnectionException implements Exception {
  final String message;
  ConnectionException(this.message);
}

// Erro ao ler/escrever no banco local
class CacheException implements Exception {
  final String message;
  CacheException(this.message);
}
```

**Failures (Erros de Negocio)**: Problemas nas regras do sistema

```dart
// Classe base para todos os Failures
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);
  
  @override
  List<Object> get props => [message];
}

// Erro no servidor
class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Erro no servidor. Tente novamente.']);
}

// Sem internet
class ConnectionFailure extends Failure {
  const ConnectionFailure([super.message = 'Sem conexao com a internet.']);
}

// Erro no banco local
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Erro ao acessar dados salvos.']);
}

// Dados de entrada invalidos
class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Dados invalidos. Verifique os campos.']);
}
```

**Por que dois tipos?**
- Exceptions sao lancadas onde o erro acontece (DataSource)
- Failures sao retornadas para quem chamou (UseCase, ViewModel)
- Isso permite tratar erros de forma elegante sem try/catch em todo lugar

```dart
// No DataSource: lanca Exception
Future<DiamondPredictionModel> getPrediction() async {
  try {
    final response = await apiClient.post('/predict', data: requestData);
    return DiamondPredictionModel.fromJson(response.data);
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionError) {
      throw ConnectionException('Nao foi possivel conectar ao servidor');
    }
    throw ServerException('Erro: ${e.message}', e.response?.statusCode);
  }
}

// No Repository: converte Exception em Failure
Future<Either<Failure, DiamondPrediction>> getPrediction() async {
  try {
    final result = await remoteDataSource.getPrediction();
    return Right(result.toEntity());  // Sucesso
  } on ConnectionException {
    return Left(ConnectionFailure());  // Falha
  } on ServerException catch (e) {
    return Left(ServerFailure(e.message));
  }
}
```

---

## Sistema de Autenticacao

### O Que E

O sistema de autenticacao controla quem pode acessar o app:
- **Login**: Usuario existente entra com email e senha
- **Registro**: Novo usuario cria uma conta
- **Logout**: Usuario sai do sistema
- **Recuperar Senha**: Usuario esqueceu a senha (simulado)

### Estrutura dos Arquivos

```
features/auth/
  login/
    login_delegate.dart      <- Interface: O QUE o login faz
    login_factory.dart       <- Fabrica: Monta a tela com dependencias
    login_service.dart       <- Servico: COMO o login funciona
    login_view.dart          <- Tela: Interface grafica
    login_view_model.dart    <- Estado: Dados da tela (email, senha, loading)
  
  register/
    register_delegate.dart
    register_factory.dart
    register_service.dart
    register_view.dart
    register_view_model.dart
  
  forgot_password/
    forgot_password_delegate.dart
    forgot_password_factory.dart
    forgot_password_service.dart
    forgot_password_view.dart
    forgot_password_view_model.dart
```

### AuthRepository Explicado

Localizacao: `lib/core/data/repositories/auth_repository.dart`

O AuthRepository centraliza todas as operacoes de autenticacao:

```dart
import 'dart:convert';
import 'package:crypto/crypto.dart';

class AuthRepository {
  
  // REGISTRAR novo usuario
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // 1. Criptografa a senha (NUNCA salvar senha em texto puro)
    final passwordHash = _hashPassword(password);
    
    // 2. Salva no storage (SQLite ou WebStorage)
    if (kIsWeb) {
      return await WebStorage.instance.registerUser(
        name: name,
        email: email,
        passwordHash: passwordHash,
      );
    } else {
      // Implementacao SQLite similar
    }
  }

  // FAZER LOGIN
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    // 1. Criptografa senha digitada
    final passwordHash = _hashPassword(password);
    
    // 2. Busca usuario e compara hash
    if (kIsWeb) {
      return await WebStorage.instance.login(email, passwordHash);
    } else {
      // Implementacao SQLite similar
    }
  }

  // SAIR
  Future<void> logout() async {
    if (kIsWeb) {
      await WebStorage.instance.logout();
    } else {
      // Limpa dados do SQLite
    }
  }

  // Criptografar senha usando SHA-256
  // Exemplo: "123456" vira "8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92"
  String _hashPassword(String password) {
    final bytes = utf8.encode(password);  // Converte string para bytes
    final hash = sha256.convert(bytes);    // Aplica SHA-256
    return hash.toString();                // Retorna como string hexadecimal
  }
}
```

### Fluxo de Login Detalhado

```
1. Usuario abre tela de login
        |
        v
2. Usuario digita email e senha
        |
        v
3. Usuario clica em "Entrar"
        |
        v
4. LoginView chama delegate.login(email, senha)
        |
        v
5. LoginService (delegate) recebe a chamada
   - Atualiza ViewModel: isLoading = true
   - Notifica View para mostrar loading
        |
        v
6. LoginService chama AuthRepository.login(email, senha)
        |
        v
7. AuthRepository:
   - Criptografa a senha com SHA-256
   - Busca usuario pelo email no banco
   - Compara hash da senha
        |
        +--> Senha correta?
        |       |
        |       v
        |    8a. Retorna UserModel
        |       |
        |       v
        |    9a. LoginService recebe usuario
        |        - Atualiza ViewModel: isLoading = false
        |        - Navega para /diamond-home
        |
        +--> Senha incorreta?
                |
                v
             8b. Retorna null
                |
                v
             9b. LoginService recebe null
                 - Atualiza ViewModel: isLoading = false
                 - Atualiza ViewModel: error = "Credenciais invalidas"
                 - View mostra mensagem de erro
```

### Seguranca

**Por que criptografar senhas?**

Se alguem acessar o banco de dados, vera apenas hashes:

| email | password_hash |
|-------|---------------|
| maria@email.com | 8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92 |

Nao e possivel descobrir "123456" a partir do hash. Para verificar login, o sistema:
1. Pega a senha digitada
2. Aplica o mesmo hash
3. Compara com o hash salvo

**Limitacoes atuais (para producao, melhorar)**:
- Usar bcrypt em vez de SHA-256 (mais seguro)
- Adicionar salt (valor aleatorio) no hash
- Implementar tokens JWT para sessao
- Adicionar autenticacao de dois fatores

---

## Design System

### O Que E Design System

Design System e uma biblioteca de componentes visuais reutilizaveis. Em vez de criar um botao diferente em cada tela, voce usa o mesmo componente padronizado em todo o app.

### Por Que Usar

1. **Consistencia**: Todos os botoes tem a mesma aparencia
2. **Velocidade**: Nao precisa recriar componentes
3. **Manutencao**: Muda em um lugar, muda em todo o app
4. **Colaboracao**: Designers e devs falam a mesma lingua

### Shadcn/UI

O Radiance usa componentes inspirados no Shadcn/UI, um Design System popular na web. Adaptamos os componentes para Flutter mantendo a mesma estetica.

### Componentes Disponiveis

Localizacao: `lib/ui/widgets/shadcn/`

#### ShadcnButton (Botao)

Arquivo: `shadcn_button.dart`

```dart
// Variantes disponiveis
enum ShadcnButtonVariant {
  primary,      // Botao principal (fundo escuro, texto claro)
  secondary,    // Botao secundario (fundo cinza)
  destructive,  // Acao destrutiva (vermelho)
  outline,      // Apenas borda, sem fundo
  ghost,        // Sem borda nem fundo (parece link)
  link,         // Parece texto com sublinhado
}

// Tamanhos
enum ShadcnButtonSize {
  sm,           // Pequeno (altura 36px)
  md,           // Medio (altura 40px) - padrao
  lg,           // Grande (altura 44px)
  icon,         // Quadrado (para icones)
}

// Uso
ShadcnButton(
  label: 'Salvar',
  variant: ShadcnButtonVariant.primary,
  size: ShadcnButtonSize.md,
  onPressed: () => salvar(),
  isLoading: false,         // Mostra spinner no lugar do texto
  icon: Icons.save,         // Icone opcional antes do texto
  fullWidth: false,         // Ocupa toda a largura disponivel
)
```

#### ShadcnInput (Campo de Texto)

Arquivo: `shadcn_input.dart`

```dart
// Variantes
enum ShadcnInputVariant {
  outline,      // Borda ao redor (padrao)
  filled,       // Fundo preenchido
  underlined,   // Apenas linha embaixo
}

// Uso
ShadcnInput(
  label: 'Email',
  hint: 'Digite seu email',
  variant: ShadcnInputVariant.outline,
  controller: emailController,
  keyboardType: TextInputType.emailAddress,
  obscureText: false,       // true para senhas
  prefix: Icon(Icons.email),
  suffix: Icon(Icons.clear),
  errorText: 'Email invalido',  // Mensagem de erro
  enabled: true,
  onChanged: (value) => print(value),
)
```

#### ShadcnCard (Cartao)

Arquivo: `shadcn_card.dart`

```dart
// Variantes
enum ShadcnCardVariant {
  elevated,     // Com sombra
  outlined,     // Com borda
  filled,       // Com fundo colorido
}

// Uso
ShadcnCard(
  variant: ShadcnCardVariant.elevated,
  padding: EdgeInsets.all(16),
  child: Column(
    children: [
      Text('Titulo'),
      Text('Conteudo do card'),
    ],
  ),
)
```

#### ShadcnSelect (Dropdown)

Arquivo: `shadcn_select.dart`

```dart
// Uso
ShadcnSelect<String>(
  label: 'Cor do diamante',
  hint: 'Selecione uma cor',
  value: selectedColor,
  items: [
    ShadcnSelectItem(value: 'D', label: 'D - Incolor'),
    ShadcnSelectItem(value: 'E', label: 'E - Incolor'),
    ShadcnSelectItem(value: 'F', label: 'F - Incolor'),
    ShadcnSelectItem(value: 'G', label: 'G - Quase incolor'),
    // ...
  ],
  onChanged: (value) => setState(() => selectedColor = value),
  searchable: true,  // Permite buscar nas opcoes
)
```

#### ShadcnSlider (Controle Deslizante)

Arquivo: `shadcn_slider.dart`

```dart
// Uso
ShadcnSlider(
  label: 'Peso (carat)',
  value: caratValue,
  min: 0.1,
  max: 5.0,
  divisions: 49,        // Passos intermediarios
  showValue: true,      // Mostra valor atual
  onChanged: (value) => setState(() => caratValue = value),
)
```

### Temas (Claro e Escuro)

Localizacao: `lib/core/theme/`

O app suporta tema claro e escuro. Os componentes se adaptam automaticamente.

#### Cores

Arquivo: `colors.dart`

```dart
class ShadcnColors {
  // TEMA CLARO
  static const Color background = Color(0xFFFFFFFF);     // Branco
  static const Color foreground = Color(0xFF0A0A0A);     // Preto
  static const Color card = Color(0xFFFFFFFF);           // Fundo de cards
  static const Color cardForeground = Color(0xFF0A0A0A); // Texto em cards
  static const Color primary = Color(0xFF18181B);        // Cor principal
  static const Color primaryForeground = Color(0xFFFAFAFA); // Texto sobre primary
  static const Color secondary = Color(0xFFF4F4F5);      // Cor secundaria
  static const Color muted = Color(0xFFF4F4F5);          // Elementos discretos
  static const Color mutedForeground = Color(0xFF71717A);// Texto discreto
  static const Color border = Color(0xFFE4E4E7);         // Bordas
  static const Color input = Color(0xFFE4E4E7);          // Borda de inputs
  static const Color ring = Color(0xFF18181B);           // Foco
  
  // TEMA ESCURO
  static const Color darkBackground = Color(0xFF0A0A0A);
  static const Color darkForeground = Color(0xFFFAFAFA);
  static const Color darkCard = Color(0xFF0A0A0A);
  static const Color darkCardForeground = Color(0xFFFAFAFA);
  static const Color darkPrimary = Color(0xFFFAFAFA);
  static const Color darkPrimaryForeground = Color(0xFF18181B);
  static const Color darkSecondary = Color(0xFF27272A);
  static const Color darkMuted = Color(0xFF27272A);
  static const Color darkMutedForeground = Color(0xFFA1A1AA);
  static const Color darkBorder = Color(0xFF27272A);
  static const Color darkInput = Color(0xFF27272A);
  static const Color darkRing = Color(0xFFD4D4D8);
  
  // CORES SEMANTICAS
  static const Color destructive = Color(0xFFEF4444);    // Vermelho (erro/perigo)
  static const Color success = Color(0xFF22C55E);        // Verde (sucesso)
  static const Color warning = Color(0xFFF59E0B);        // Amarelo (atencao)
  static const Color info = Color(0xFF3B82F6);           // Azul (informacao)
}
```

#### ThemeProvider (Alternar Tema)

Arquivo: `lib/core/providers/theme_provider.dart`

```dart
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;
  
  // Alternar entre claro e escuro
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light 
      ? ThemeMode.dark 
      : ThemeMode.light;
    notifyListeners();  // Avisa a UI para reconstruir
  }
  
  // Definir tema especifico
  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }
}

// Uso em qualquer lugar do app
context.read<ThemeProvider>().toggleTheme();

// Verificar tema atual
final isDark = context.watch<ThemeProvider>().isDarkMode;
```

---

## Gerenciamento de Estado

### O Que E Gerenciamento de Estado

Estado sao os dados que mudam durante a execucao do app. Por exemplo:
- Usuario esta logado ou nao?
- A lista de predicoes ja foi carregada?
- O formulario esta em modo de edicao?

Gerenciar estado significa controlar quando e como esses dados mudam, e garantir que a interface se atualize corretamente.

### Provider + ChangeNotifier

O Radiance usa Provider com ChangeNotifier, uma solucao simples e eficiente do Flutter.

**ChangeNotifier**: Classe que avisa quando algo mudou
**Provider**: Disponibiliza o ChangeNotifier para toda a arvore de widgets

### Como Funciona na Pratica

```dart
// 1. CRIAR O VIEWMODEL (ChangeNotifier)
class DiamondPredictionViewModel extends ChangeNotifier {
  // Estado privado
  PredictionState _state = PredictionState.initial;
  DiamondPrediction? _currentPrediction;
  String? _errorMessage;
  List<DiamondPrediction> _history = [];

  // Getters publicos (somente leitura)
  PredictionState get state => _state;
  DiamondPrediction? get currentPrediction => _currentPrediction;
  String? get errorMessage => _errorMessage;
  List<DiamondPrediction> get history => _history;
  
  // Getters de conveniencia
  bool get isLoading => _state == PredictionState.loading;
  bool get hasError => _state == PredictionState.error;
  bool get hasData => _currentPrediction != null;

  // Metodo para fazer predicao
  Future<void> predict(PredictionParams params) async {
    // 1. Atualiza estado para "carregando"
    _state = PredictionState.loading;
    _errorMessage = null;
    notifyListeners();  // AVISA A UI PARA RECONSTRUIR

    // 2. Chama o caso de uso
    final result = await getPredictionUseCase(params);
    
    // 3. Trata o resultado
    result.fold(
      // Se deu erro (Left)
      (failure) {
        _state = PredictionState.error;
        _errorMessage = failure.message;
      },
      // Se deu certo (Right)
      (prediction) {
        _state = PredictionState.success;
        _currentPrediction = prediction;
        _history.insert(0, prediction);  // Adiciona ao historico
      },
    );
    
    notifyListeners();  // AVISA A UI NOVAMENTE
  }

  // Limpar estado
  void clear() {
    _state = PredictionState.initial;
    _currentPrediction = null;
    _errorMessage = null;
    notifyListeners();
  }
}

// Estados possiveis
enum PredictionState {
  initial,   // Estado inicial, nada aconteceu
  loading,   // Carregando dados
  success,   // Operacao bem sucedida
  error,     // Ocorreu um erro
}
```

```dart
// 2. DISPONIBILIZAR O VIEWMODEL (Provider)
// No main.dart ou no ponto onde precisa
ChangeNotifierProvider(
  create: (_) => DiamondPredictionViewModel(),
  child: MaterialApp(...),
)

// Ou para multiplos providers
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
    ChangeNotifierProvider(create: (_) => DiamondPredictionViewModel()),
  ],
  child: MaterialApp(...),
)
```

```dart
// 3. CONSUMIR NA VIEW
class PredictionView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<DiamondPredictionViewModel>(
      builder: (context, viewModel, child) {
        // Este bloco reconstroi sempre que notifyListeners() e chamado
        
        if (viewModel.isLoading) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Calculando preco...'),
              ],
            ),
          );
        }
        
        if (viewModel.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error, color: Colors.red, size: 48),
                SizedBox(height: 16),
                Text(viewModel.errorMessage ?? 'Erro desconhecido'),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => viewModel.clear(),
                  child: Text('Tentar novamente'),
                ),
              ],
            ),
          );
        }
        
        if (viewModel.hasData) {
          final prediction = viewModel.currentPrediction!;
          return Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Preco Previsto'),
                  Text(
                    '\$${prediction.predictedPrice.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          );
        }
        
        // Estado inicial - mostra formulario
        return PredictionForm();
      },
    );
  }
}
```

### Metodos de Acesso ao Provider

```dart
// LEITURA com rebuild (escuta mudancas)
// Usa quando precisa reconstruir a UI
final viewModel = context.watch<DiamondPredictionViewModel>();
final isDark = context.watch<ThemeProvider>().isDarkMode;

// LEITURA sem rebuild (nao escuta mudancas)
// Usa em callbacks e metodos
final viewModel = context.read<DiamondPredictionViewModel>();
void onPressed() {
  context.read<DiamondPredictionViewModel>().predict(params);
}

// SELETOR (escuta apenas uma parte)
// Mais eficiente quando so precisa de um campo
final isLoading = context.select<DiamondPredictionViewModel, bool>(
  (vm) => vm.isLoading,
);

// Consumer (builder pattern)
// Mais legivel para blocos maiores
Consumer<DiamondPredictionViewModel>(
  builder: (context, viewModel, child) {
    return Text(viewModel.state.toString());
  },
)
```

---

## Navegacao e Rotas

### O Que E GoRouter

GoRouter e uma biblioteca de navegacao para Flutter que usa URLs (como na web). Em vez de empilhar telas com Navigator.push, voce vai para uma rota como "/diamond-home".

### Por Que Usar GoRouter

1. **URLs legíveis**: Facil de entender onde o usuario esta
2. **Deep linking**: Pode abrir uma tela especifica por link
3. **Web compatível**: URLs funcionam no navegador
4. **Tipagem**: Passar dados entre telas de forma segura

### Configuracao

Localizacao: `lib/core/router/app_router.dart`

```dart
final GoRouter router = GoRouter(
  initialLocation: '/',  // Rota inicial ao abrir o app
  
  routes: [
    // LANDING PAGE (tela inicial)
    GoRoute(
      path: '/',
      name: 'landing',
      builder: (context, state) => const LandingPage(),
    ),
    
    // LOGIN
    GoRoute(
      path: '/diamond-login',
      name: 'diamond-login',
      builder: (context, state) => LoginFactory.create(context),
    ),
    
    // REGISTRO
    GoRoute(
      path: '/auth/register',
      name: 'auth-register',
      builder: (context, state) => RegisterFactory.create(context),
    ),
    
    // RECUPERAR SENHA
    GoRoute(
      path: '/auth/forgot-password',
      name: 'auth-forgot-password',
      builder: (context, state) => ForgotPasswordFactory.create(context),
    ),
    
    // DASHBOARD (apos login)
    GoRoute(
      path: '/diamond-home',
      name: 'diamond-home',
      builder: (context, state) => HomeFactory.create(context),
    ),
    
    // NOVA PREDICAO
    GoRoute(
      path: '/diamond-prediction',
      name: 'diamond-prediction',
      builder: (context, state) => PredictionFactory.create(context),
    ),
    
    // HISTORICO
    GoRoute(
      path: '/diamond-history',
      name: 'diamond-history',
      builder: (context, state) => HistoryFactory.create(context),
    ),
    
    // DESIGN SYSTEM SHOWCASE
    GoRoute(
      path: '/design-system',
      name: 'design-system',
      builder: (context, state) => const ShowcasePage(),
    ),
    
    // SHOWCASE DE COMPONENTES INDIVIDUAIS
    GoRoute(
      path: '/buttons',
      name: 'buttons',
      builder: (context, state) => const ButtonsPage(),
    ),
    GoRoute(
      path: '/inputs',
      name: 'inputs',
      builder: (context, state) => const InputsPage(),
    ),
    GoRoute(
      path: '/cards',
      name: 'cards',
      builder: (context, state) => const CardsPage(),
    ),
    // ... outras rotas de showcase
  ],
);
```

### Tabela de Rotas

| Rota | Nome | Descricao | Requer Login |
|------|------|-----------|--------------|
| `/` | landing | Pagina inicial | Nao |
| `/diamond-login` | diamond-login | Tela de login | Nao |
| `/auth/register` | auth-register | Cadastro de usuario | Nao |
| `/auth/forgot-password` | auth-forgot-password | Recuperar senha | Nao |
| `/diamond-home` | diamond-home | Dashboard principal | Sim |
| `/diamond-prediction` | diamond-prediction | Formulario de predicao | Sim |
| `/diamond-history` | diamond-history | Historico de predicoes | Sim |
| `/design-system` | design-system | Showcase do Design System | Nao |
| `/buttons` | buttons | Exemplos de botoes | Nao |
| `/inputs` | inputs | Exemplos de inputs | Nao |
| `/cards` | cards | Exemplos de cards | Nao |
| `/modals` | modals | Exemplos de modais | Nao |
| `/sliders` | sliders | Exemplos de sliders | Nao |
| `/tables` | tables | Exemplos de tabelas | Nao |
| `/tooltips` | tooltips | Exemplos de tooltips | Nao |

### Como Navegar

```dart
// IR PARA UMA ROTA (substitui a pilha)
// Usa quando nao quer permitir voltar
context.go('/diamond-home');

// IR POR NOME (com parametros)
context.goNamed('diamond-prediction', extra: {'initialCarat': 1.5});

// EMPILHAR ROTA (permite voltar)
// Usa quando quer manter a tela anterior
context.push('/diamond-prediction');

// VOLTAR
context.pop();

// VOLTAR COM RESULTADO
context.pop(resultadoDaOperacao);

// SUBSTITUIR ROTA ATUAL
context.pushReplacement('/diamond-home');
```

### Passando Dados Entre Telas

```dart
// ENVIANDO
context.goNamed(
  'diamond-prediction',
  extra: {
    'diamond': diamondData,
    'editMode': true,
  },
);

// RECEBENDO
GoRoute(
  path: '/diamond-prediction',
  name: 'diamond-prediction',
  builder: (context, state) {
    // Recupera os dados
    final extra = state.extra as Map<String, dynamic>?;
    final diamond = extra?['diamond'] as Diamond?;
    final editMode = extra?['editMode'] as bool? ?? false;
    
    return PredictionFactory.create(
      context,
      initialDiamond: diamond,
      editMode: editMode,
    );
  },
)
```

---

## Referencia Rapida de Localizacao

Esta secao serve como indice para encontrar rapidamente qualquer arquivo do projeto.

### Configuracao do App

| O Que Preciso Fazer | Onde Encontrar |
|---------------------|----------------|
| Mudar a tela inicial do app | `lib/core/router/app_router.dart` (initialLocation) |
| Adicionar nova dependencia | `lib/core/di/dependency_injection.dart` |
| Mudar cores do tema | `lib/core/theme/colors.dart` |
| Mudar fontes/tipografia | `lib/core/theme/typography.dart` |
| Configurar Dio/HTTP | `lib/core/network/api_client.dart` |
| Mudar URL da API | `lib/data/datasources/remote/api_endpoints.dart` |

### Funcionalidades

| Funcionalidade | Pasta |
|----------------|-------|
| Login | `lib/features/auth/login/` |
| Registro | `lib/features/auth/register/` |
| Recuperar senha | `lib/features/auth/forgot_password/` |
| Dashboard | `lib/features/diamond_prediction/home/` |
| Fazer predicao | `lib/features/diamond_prediction/prediction/` |
| Ver historico | `lib/features/diamond_prediction/history/` |
| Pagina inicial | `lib/features/diamond_prediction/landing/` |

### Componentes de UI

| Componente | Arquivo |
|------------|---------|
| Botao Shadcn | `lib/ui/widgets/shadcn/shadcn_button.dart` |
| Input Shadcn | `lib/ui/widgets/shadcn/shadcn_input.dart` |
| Card Shadcn | `lib/ui/widgets/shadcn/shadcn_card.dart` |
| Select Shadcn | `lib/ui/widgets/shadcn/shadcn_select.dart` |
| Slider Shadcn | `lib/ui/widgets/shadcn/shadcn_slider.dart` |
| Botao de tema | `lib/ui/widgets/theme_toggle_button.dart` |

### Banco de Dados

| Plataforma | Arquivo |
|------------|---------|
| Mobile (SQLite) | `lib/core/data/database/local_database.dart` |
| Web (Memoria) | `lib/core/data/database/web_storage.dart` |

### Clean Architecture

| Camada | Pasta |
|--------|-------|
| Entidades | `lib/domain/entities/` |
| Use Cases | `lib/domain/usecases/` |
| Interfaces Repository | `lib/domain/repositories/` |
| Models (JSON) | `lib/data/models/` |
| Impl Repository | `lib/data/repositories/` |
| DataSources | `lib/data/datasources/` |

### Tratamento de Erros

| Tipo | Arquivo |
|------|---------|
| Exceptions (tecnicos) | `lib/core/errors/exceptions.dart` |
| Failures (negocio) | `lib/core/errors/failures.dart` |

---

## Fluxo Completo de Uma Predicao

Para entender como tudo funciona junto, veja o fluxo completo quando um usuario faz uma predicao:

```
1. USUARIO
   Abre o app e vai para /diamond-prediction
   |
   v
2. ROUTER (app_router.dart)
   Reconhece a rota e chama PredictionFactory.create()
   |
   v
3. FACTORY (prediction_factory.dart)
   Cria ViewModel, Service e View conectados
   |
   v
4. VIEW (prediction_view.dart)
   Mostra formulario com campos: carat, cut, color, etc.
   Usuario preenche e clica "Prever Preco"
   |
   v
5. SERVICE (prediction_service.dart)
   Recebe chamada delegate.predict()
   Atualiza ViewModel para loading
   |
   v
6. VIEWMODEL (prediction_view_model.dart)
   Chama notifyListeners()
   View reconstroi mostrando spinner
   |
   v
7. USE CASE (get_prediction.dart)
   Valida os dados de entrada
   Se invalido, retorna ValidationFailure
   Se valido, chama Repository
   |
   v
8. REPOSITORY (prediction_repository_impl.dart)
   Verifica conexao com internet
   Se offline, retorna ConnectionFailure
   Se online, chama RemoteDataSource
   |
   v
9. REMOTE DATASOURCE (prediction_remote_datasource.dart)
   Faz POST para https://web-production-94f5d.up.railway.app/predict
   Envia JSON com dados do diamante
   |
   v
10. API EXTERNA (Railway)
    Processa dados com modelo de Machine Learning
    Retorna { "predicted_price": 15432.50 }
    |
    v
11. REMOTE DATASOURCE
    Converte JSON para DiamondPredictionModel
    |
    v
12. REPOSITORY
    Converte Model para Entity
    Salva no LocalDataSource (historico)
    Retorna Right(DiamondPrediction)
    |
    v
13. USE CASE
    Retorna Either<Failure, DiamondPrediction>
    |
    v
14. SERVICE
    Atualiza ViewModel com resultado
    |
    v
15. VIEWMODEL
    state = success
    currentPrediction = resultado
    Chama notifyListeners()
    |
    v
16. VIEW
    Consumer reconstroi
    Mostra card com preco previsto: $15,432.50
    |
    v
17. USUARIO
    Ve o resultado na tela
```

---

## Glossario de Termos

| Termo | Significado |
|-------|-------------|
| **Widget** | Componente visual do Flutter (botao, texto, container) |
| **StatelessWidget** | Widget que nao muda depois de criado |
| **StatefulWidget** | Widget que pode mudar (tem estado) |
| **ChangeNotifier** | Classe que avisa quando dados mudam |
| **Provider** | Forma de compartilhar dados entre widgets |
| **Consumer** | Widget que escuta mudancas do Provider |
| **GoRouter** | Biblioteca de navegacao com URLs |
| **Dio** | Biblioteca para fazer requisicoes HTTP |
| **GetIt** | Container para injecao de dependencias |
| **Either** | Tipo que pode ser sucesso (Right) ou erro (Left) |
| **Entity** | Representacao pura de um conceito (sem JSON/banco) |
| **Model** | Entity com capacidade de conversao JSON |
| **Repository** | Abstrai acesso a dados (API/banco) |
| **DataSource** | Fonte especifica de dados (API ou banco) |
| **UseCase** | Uma acao que o sistema pode fazer |
| **ViewModel** | Gerencia estado de uma tela |
| **Delegate** | Interface que define acoes disponiveis |
| **Service** | Implementa as acoes do Delegate |
| **Factory** | Cria objetos complexos |
| **SHA-256** | Algoritmo de criptografia (hash) |
| **JWT** | Token de autenticacao (JSON Web Token) |
| **Deep Link** | Link que abre uma tela especifica do app |

---

## Como Executar o Projeto

### Pre-requisitos

1. Flutter SDK instalado (versao 3.x)
2. Dart SDK (vem com Flutter)
3. Android Studio ou VS Code
4. Chrome (para rodar na web)

### Comandos

```bash
# Baixar dependencias
flutter pub get

# Rodar na web
flutter run -d chrome

# Rodar no Android
flutter run -d android

# Rodar no iOS (apenas macOS)
flutter run -d ios

# Gerar APK
flutter build apk

# Gerar Web
flutter build web

# Analisar codigo
flutter analyze

# Rodar testes
flutter test
```

### Credenciais de Teste (Web)

O WebStorage cria um usuario de teste automaticamente:
- Email: `teste@teste.com`
- Senha: `123456`

---

Atualizado em Dezembro de 2025
