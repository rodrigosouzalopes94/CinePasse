Plataforma CinePasse: Documentação de Lançamento

Propósito: Apresentar as funcionalidades e as regras de negócio implementadas no Aplicativo Móvel e no Painel de Gestão (Backoffice), com foco na experiência do usuário e na eficiência operacional.

Desenvolvimento: Aplicativo Mobile (Flutter) e Gestão Web (React)
Base de Dados: Google Firebase/Firestore

1. Regras de Negócio e Planos de Assinatura (O Coração do App)

O sistema CinePasse opera sob um modelo de assinatura, onde os benefícios são aplicados automaticamente na reserva de ingressos.

1.1. Detalhamento dos Planos

|

| Plano | Preço (Exemplo) | Benefício na Reserva | Regra de Uso |
| Passe Premium | R$ 49,90/mês | Ingresso Gratuito. O usuário não paga nada na reserva. | Válido para o titular, 1 ingresso por sessão. |
| Plano Família | R$ 89,90/mês | Ingresso Gratuito. O usuário não paga nada na reserva. | Válido para o titular e até 3 membros adicionais (total de 4 usuários). |
| Básico (Gratuito) | R$ 0,00 | Pagamento Avulso (R$ 25,00). O usuário deve pagar o valor do ingresso na reserva. | Não possui limite de ingressos, mas requer pagamento por uso. |

1.2. Processo de Reserva (Regra Crítica)

Todo ingresso, seja ele pago (Avulso) ou gratuito (Plano), segue o mesmo fluxo para garantir a integridade do assento:

Reserva (App Mobile): O usuário seleciona o filme e o horário, e o sistema registra a solicitação com o status "Pendente".

Verificação (Backoffice): O Painel Administrativo recebe a notificação em tempo real. O Admin verifica a validade do plano ou a confirmação do pagamento avulso.

Aprovação: O Admin altera o status para "Aprovado".

Voucher Imediato: O ingresso aparece na aba "Meus Ingressos" do usuário, pronto para ser usado.

2. Aplicativo Mobile (Flutter) - Foco no Usuário

O aplicativo foi desenvolvido com foco em uma experiência de usuário rápida e intuitiva.

2.1. Funcionalidades de Acesso e Perfil

| Módulo | O que o Usuário Faz | Detalhe de Segurança/Uso |
| Login/Cadastro | Cria e acessa sua conta com segurança de nível Firebase. | Os dados complementares (CPF, Idade) são salvos no Firestore, mas o acesso à conta é via Firebase Authentication. |
| Edição de Perfil | O usuário pode corrigir seu Nome e Idade. | A alteração do Plano é feita na aba "Planos" (Checkout). O CPF e Email são mantidos como read-only para proteger a identidade. |
| Alternar Tema | Muda o aplicativo para o Modo Escuro ou Claro com um clique. | O tema é persistido localmente para manter a preferência do usuário. |

2.2. Funcionalidades de Conteúdo e Vouchers

| Módulo | O que o Usuário Vê | Como Funciona |
| Catálogo Home | Vê todos os filmes "Em Cartaz" em tempo real. | O aplicativo recebe as informações diretamente da coleção filmes do Firestore via Stream. |
| Reserva com Timer | Ao iniciar a reserva, um cronômetro de 5 minutos começa a contar. | Isso evita que assentos fiquem bloqueados indefinidamente por usuários indecisos. Se o tempo esgotar, a reserva é cancelada (o modal fecha). |
| Meus Ingressos | Vê todos os vouchers comprados ou reservados. | Utiliza um filtro em tempo real: Apenas ingressos com status "Aprovado" são exibidos para evitar confusão no momento da entrada no cinema. |

3. Painel Administrativo (React/Web) - Foco Operacional

O Backoffice é o centro de controle para a equipe de gestão, garantindo a rápida aprovação de vendas e a atualização do catálogo.

3.1. Governança e Acesso

| Módulo | Benefício Operacional | Segurança |
| Login Admin | Acesso restrito apenas a contas com permissão de Administrador (flag isAdmin: true no Firebase). | Bloqueado por Regras de Segurança do Firestore para proteger dados sensíveis. |
| Dashboard | Visão instantânea das métricas críticas (Total de Vendas, Tickets Pendentes e Catálogo Ativo). | Permite tomada de decisão rápida sobre a saúde das operações. |
| Gestão de Usuários | A equipe pode consultar perfis, CPF, Idade, e mudar o plano de um usuário manualmente (Upgrade/Downgrade forçado). | Essencial para o suporte e resolução de problemas de cobrança/benefícios. |

3.2. Controle de Tickets e Catálogo

| Módulo | O que a Equipe Faz | Agilidade |
| Validação de Tickets | Listagem instantânea de todos os tickets Pendentes. A equipe clica em Aprovar ou Rejeitar. | A aprovação é imediata, e o voucher aparece no celular do cliente em tempo real (segundos) devido ao uso de Streams do Firestore. |
| Catálogo de Filmes | Cria, edita e exclui filmes. | Garante que o App Mobile esteja sempre atualizado sem a necessidade de intervenção do desenvolvimento. |

4. Segurança e Integridade (Garantia de 100% de Funcionamento)

Para assegurar que o App e o Backoffice funcionem corretamente no ambiente de produção:

Chaves SHA-1: As chaves de assinatura do aplicativo (tanto a chave de Upload quanto a chave oficial de Assinatura do Google Play) foram registradas no Firebase Console. Isso é crucial para garantir que o Login e as Notificações funcionem após o download na Play Store.

Regras de Segurança (Firestore Rules):

Anti-Fraude: A regra central impede que o usuário crie um ticket com status "Aprovado". Todo ticket deve ser criado como "Pendente", forçando a validação humana ou de sistema.

Acesso de Admin: Apenas a conta de Admin tem permissão para mudar o status de um ticket e modificar o catálogo de filmes.

Este modelo garante um sistema ágil, seguro e com controle total sobre as regras de negócio no Backoffice.
