/// Constantes da API de Predição de Diamantes
/// 
/// Este arquivo contém as configurações de conexão com a API
/// de machine learning para predição de preços de diamantes.
/// 
/// A API utiliza FastAPI (Python) com modelos TensorFlow treinados.
class ApiConstants {
  /// URL base da API de predição
  /// Nota: Em desenvolvimento local, usar localhost:8005
  /// Para produção, substituir pela URL do servidor
  static const String baseUrl = 'http://localhost:8005';
  
  /// Endpoint para predição de preço do diamante
  /// Método: POST
  /// 
  /// Request body (JSON):
  /// {
  ///   "carat": double,      // Peso do diamante em quilates
  ///   "cut": string,        // Qualidade do corte (Fair, Good, Very Good, Premium, Ideal)
  ///   "color": string,      // Cor do diamante (D, E, F, G, H, I, J)
  ///   "clarity": string,    // Claridade (I1, SI2, SI1, VS2, VS1, VVS2, VVS1, IF)
  ///   "depth": double,      // Profundidade total percentual
  ///   "table": double,      // Largura do topo percentual
  ///   "x": double,          // Comprimento em mm
  ///   "y": double,          // Largura em mm
  ///   "z": double           // Profundidade em mm
  /// }
  /// 
  /// Response (JSON):
  /// {
  ///   "predicted_price": double,
  ///   "details": {
  ///     "model1": double,
  ///     "model2": double
  ///   },
  ///   "input": {...}
  /// }
  static const String predictEndpoint = '/predict';
  
  /// Endpoint para verificar status da API
  static const String healthEndpoint = '/';
  
  /// Timeout padrão para requisições (em segundos)
  static const int requestTimeout = 30;
  
  /// Opções de corte do diamante (cut)
  static const List<String> cutOptions = [
    'Fair',
    'Good',
    'Very Good',
    'Premium',
    'Ideal',
  ];
  
  /// Opções de cor do diamante (color)
  /// D = melhor, J = pior
  static const List<String> colorOptions = [
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
  ];
  
  /// Opções de claridade do diamante (clarity)
  /// IF = melhor, I1 = pior
  static const List<String> clarityOptions = [
    'I1',
    'SI2',
    'SI1',
    'VS2',
    'VS1',
    'VVS2',
    'VVS1',
    'IF',
  ];
  
  /// Valores mínimos e máximos para os campos numéricos
  static const double minCarat = 0.2;
  static const double maxCarat = 5.01;
  static const double minDepth = 43.0;
  static const double maxDepth = 79.0;
  static const double minTable = 43.0;
  static const double maxTable = 95.0;
  static const double minDimension = 0.0;
  static const double maxDimension = 60.0;
}
