# Estrutura do Projeto Flutter - Clean Architecture com BLoC

Este projeto segue os princípios da **Clean Architecture** e utiliza o padrão **BLoC** para gerenciar o estado da aplicação.

## Estrutura de Pastas

A estrutura do projeto está organizada conforme descrito abaixo:

### `lib/app`

#### **Core/Network**
- **`dio.dart`**: Configuração e gerenciamento de requisições HTTP utilizando a biblioteca Dio.

#### **Data**
- **`errors/`**
  - **`error_mapper.dart`**: Classe responsável por mapear e tratar erros que ocorrem durante a execução do aplicativo.

- **`models/`**
  - **`city_model.dart`**: Modelo de dados que representa a cidade, utilizado no acesso a dados (API ou cache).
  - **`city_model.g.dart`**: Arquivo gerado automaticamente, possivelmente pelo pacote `json_serializable`.

- **`repositories/`**
  - **`city_repository.dart`**: Implementação concreta do repositório de cidades, responsável por buscar os dados de diferentes fontes (API, cache, etc.).
  - **`i_city_repository.dart`**: Interface do repositório, garantindo a inversão de dependências.

#### **Domain**
- **`entities/`**
  - **`city_entity.dart`**: Entidade de domínio que representa a cidade, contendo apenas regras de negócio e dados essenciais.

- **`use_cases/`**
  - **`cities_use_case.dart`**: Caso de uso para gerenciar a lógica de negócios associada às cidades (ex.: busca de cidades, filtragem, etc.).

#### **Drivers**
- **`cache/`**
  - **`cache.dart`**: Implementação para armazenar e recuperar dados em cache.

- **`injects/`**
  - **`injects.dart`**: Configuração de injeção de dependências para os principais módulos do aplicativo.

#### **Presentation**
- **`blocs/`**
  - **`cities_bloc.dart`**: Gerenciador de estado BLoC para lidar com eventos e estados relacionados às cidades.

- **`pages/`**
  - **`cities_page.dart`**: Tela principal que exibe a lista de cidades.
  - **`city_details.dart`**: Tela que exibe os detalhes de uma cidade selecionada.

#### **Arquivo Principal**
- **`main.dart`**: Ponto de entrada do aplicativo. Geralmente contém a configuração inicial do aplicativo, como a injeção de dependências e a configuração do tema.

## Detalhes Técnicos

### Clean Architecture
A aplicação está dividida em três camadas principais:
1. **Data**: Responsável por acessar e fornecer dados de fontes externas, como APIs ou banco de dados local.
2. **Domain**: Contém as regras de negócio e lógica principal. Não depende de nenhuma biblioteca ou framework.
3. **Presentation**: Gerencia a interface do usuário e o estado da aplicação, utilizando o padrão BLoC.

### Gerenciamento de Estado
O projeto utiliza o padrão **BLoC (Business Logic Component)** para gerenciar eventos e estados de forma reativa. 
- Os eventos representam ações disparadas pelo usuário ou pela aplicação.
- Os estados refletem mudanças na interface do usuário.

### Injeção de Dependências
- **`injects.dart`** gerencia a criação e o fornecimento de dependências, garantindo que cada módulo receba apenas o que precisa.

## Tecnologias Utilizadas
- **Flutter**: Framework para desenvolvimento de interfaces nativas.
- **Dio**: Biblioteca para requisições HTTP.
- **BLoC**: Gerenciamento de estado reativo.


## Como Executar
1. Instale as dependências do projeto:
   ```bash
   flutter pub get
   ```
2. Execute o aplicativo:
   ```bash
   flutter run
   ```
## Como Executar Tests
1. Execute o aplicativo:
   ```bash
   flutter test
   ```

---

Este README oferece uma visão geral da organização do projeto. Modifique conforme necessário para atender às suas necessidades específicas.
