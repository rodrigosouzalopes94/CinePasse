🎬 CinePasse App

CinePasse é uma aplicação mobile desenvolvida em Flutter que revoluciona a experiência de ir ao cinema. Focado em um modelo de assinatura (SaaS), o app permite que usuários assinem planos mensais para obter ingressos, reservem assentos e gerenciem seus vouchers digitalmente.

📱 Telas e Funcionalidades

Catálogo de Filmes

Planos de Assinatura

Meus Ingressos



Autenticação Completa: Login, Cadastro e Recuperação de Senha via E-mail (Firebase Auth).

Catálogo em Tempo Real: Listagem de filmes atualizada instantaneamente (Firestore).

Sistema de Assinaturas: Planos "Premium" e "Família" com benefícios exclusivos.

Checkout Simulado: Fluxo de pagamento com validação de Cartão de Crédito e Pix.

Gestão de Vouchers: Geração de QR Code e acompanhamento do status de aprovação (Pendente/Aprovado).

Temas: Suporte completo a Dark Mode e Light Mode.

🛠️ Tecnologias Utilizadas

Frontend: Flutter (Dart)

Backend as a Service: Firebase

Authentication: Gestão de identidade.

Cloud Firestore: Banco de dados NoSQL em tempo real.

Gerenciamento de Estado: Provider (ChangeNotifier).

Arquitetura: Feature-First / Clean Architecture simplificada.

🚀 Como Rodar o Projeto

Pré-requisitos

Flutter SDK instalado.

Emulador Android/iOS ou dispositivo físico configurado.

Conta no Firebase.

Passo a Passo

Clone o repositório:

git clone [https://github.com/SEU_USUARIO/cine_passe_app.git](https://github.com/SEU_USUARIO/cine_passe_app.git)
cd cine_passe_app


Instale as dependências:

flutter pub get


Configuração do Firebase:

Este projeto depende do arquivo firebase_options.dart.

Siga as instruções no arquivo FIREBASE_SETUP.md para configurar seu ambiente.

Execute o App:

flutter run


📂 Estrutura do Projeto

O projeto segue uma estrutura organizada por funcionalidades (features):

lib/
├── api/            # Comunicação direta com Firestore
├── core/           # Modelos, Temas e Utilitários globais
├── features/       # Módulos do App (Auth, Movies, Plans, Tickets)
├── services/       # Serviços de Lógica (AuthService)
└── widgets/        # Componentes visuais reutilizáveis


🤝 Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir Issues ou enviar Pull Requests.

