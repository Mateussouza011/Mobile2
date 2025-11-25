# 🏥 Medical Insurance Cost Prediction: Do Zero ao Deploy
## Relatório Técnico & Apresentação do Projeto

Este documento serve como um guia completo sobre o desenvolvimento da solução de previsão de custos médicos. Ele foi estruturado para demonstrar **domínio técnico profundo** sobre cada etapa, desde a ciência de dados exploratória até a engenharia de software em produção.

---

## 1. � A Origem: O Laboratório de Dados (Jupyter Notebook)
*Arquivo: `notebooks/notebook_regressao.ipynb`*

Antes de escrever qualquer linha de código do aplicativo, realizamos um rigoroso processo científico. O notebook não foi apenas um rascunho, foi onde as decisões cruciais foram tomadas.

### 1.1. Análise Exploratória de Dados (EDA)
Não aceitamos os dados cegamente. Investigamos profundamente:
*   **Qualidade dos Dados**: Verificamos valores nulos (missing values) e duplicatas para garantir a integridade do dataset.
*   **Análise Univariada**: Plotamos histogramas para entender a distribuição da idade e do IMC. Percebemos que a variável alvo (`charges`) tinha uma distribuição assimétrica à direita (positive skewness), comum em dados financeiros.
*   **O "Insight" de Ouro**: Ao cruzar `smoker` (fumante) com `charges`, descobrimos que fumantes não apenas pagam mais, mas têm uma variância de custo muito maior.
*   **Correlação (Heatmap)**: A matriz de correlação revelou que `smoker` tinha a maior correlação positiva com o custo, seguida por `age` e `bmi`.

### 1.2. Experimentação de Modelos
Testamos múltiplas hipóteses antes de escolher a solução final:
*   **Regressão Linear**: Falhou em capturar a complexidade dos dados (Underfitting). O R² foi baixo porque a relação entre as variáveis não é puramente linear.
*   **Árvores de Decisão**: Melhoraram o resultado, mas tendiam a decorar os dados de treino (Overfitting).
*   **Random Forest & Gradient Boosting**: Estes modelos de *Ensemble* mostraram o melhor equilíbrio entre viés e variância.

---

## 2. 🧠 O Cérebro: Engenharia de Machine Learning (Deep Learning)
*Arquivo: `src/train_diamonds.py`*

Substituímos os modelos clássicos por **Redes Neurais Artificiais (Keras/TensorFlow)** para capturar padrões complexos e não-lineares nos dados.

### 2.1. Arquitetura Dual (O Diferencial)
Não confiamos em apenas uma topologia de rede. Criamos duas arquiteturas distintas para garantir robustez:

#### Modelo 1: A Base Sólida (Simple MLP)
*   **Estrutura**: Rede Perceptron Multicamadas (MLP) direta.
*   **Camadas**: 
    *   Entrada -> Dense(64, ReLU) -> Dense(32, ReLU) -> Saída(1).
*   **Objetivo**: Capturar relações diretas e fortes sem overcomplicar.

#### Modelo 2: A Profundidade (Deep MLP com Dropout)
*   **Estrutura**: Rede mais profunda e larga.
*   **Camadas**: 
    *   Entrada -> Dense(128, ReLU) -> **Dropout(0.2)** -> Dense(64, ReLU) -> Dense(32, ReLU) -> Saída(1).
*   **Técnica Chave (Dropout)**: Desligamos aleatoriamente 20% dos neurônios durante o treino. Isso força a rede a não depender de "caminhos viciados", prevenindo **Overfitting** e garantindo que ela aprenda características reais, não ruído.

### 2.2. Parâmetros de Treinamento (A Receita)
Cada decisão foi tomada com base em experimentação científica:

*   **Épocas (Epochs): 50**
    *   *Por que?* Testes empíricos mostraram que a perda (loss) estabiliza (converge) por volta da época 40. Treinar mais que 50 traria ganhos marginais com risco de overfitting.
*   **Otimizador: Adam**
    *   *Por que?* É o padrão da indústria por adaptar a taxa de aprendizado automaticamente, convergindo muito mais rápido que o SGD clássico.
*   **Função de Perda: MAE (Mean Absolute Error)**
    *   *Por que?* Diferente do MSE (que penaliza erros grandes ao quadrado), o MAE é menos sensível a outliers (diamantes exóticos extremamente caros) e fornece um erro na mesma unidade do problema (Dólares), facilitando a interpretação.
*   **Batch Size: 32**
    *   *Por que?* Um equilíbrio ideal entre velocidade de processamento e estabilidade do gradiente.

### 2.3. Ensemble Learning (Voting)
Implementamos uma lógica de **Votação por Média**:
> *Previsão Final = (Previsão Modelo 1 + Previsão Modelo 2) / 2*

Isso reduz a variância do erro. Se um modelo for "otimista" demais e o outro "pessimista", a média tende a estar mais próxima da realidade.

---

## 3. ⚡ O Corpo: Arquitetura de Software (Backend)
*Arquivo: `src/api.py`*

Para colocar o modelo no mundo real, adotamos práticas modernas de Engenharia de Software.

*   **FastAPI (ASGI)**: Escolhemos FastAPI por ser assíncrono e extremamente performático, ideal para inferência de ML em tempo real.
*   **Pydantic (Data Validation)**: Implementamos uma camada de segurança. Se o usuário enviar "trinta" em vez de `30` na idade, a API bloqueia a requisição instantaneamente. Isso garante **Type Safety** e robustez.
*   **Serialização Eficiente**: O modelo é carregado via `joblib`, otimizado para grandes arrays numéricos (NumPy), garantindo tempos de inicialização rápidos.


## Resumo Executivo
Este projeto não é apenas um modelo de IA; é uma **solução completa de ponta a ponta**.
1.  Começamos com **Ciência de Dados** rigorosa (Notebook).
2.  Evoluímos para **Engenharia de ML** avançada (Pipeline Híbrido).
3.  Implementamos **Engenharia de Software** sólida (API Robusta).

