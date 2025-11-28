class PlanModel {
  final String id;
  final String nome;
  final String descricao;
  final double preco;
  final List<String> beneficios;
  final bool isPopular;
  final int maxMembros; // Novo: para controlar a regra do plano família

  const PlanModel({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.preco,
    required this.beneficios,
    this.isPopular = false,
    this.maxMembros = 1,
  });

  // -------------------------------------------------------------------
  // DADOS FIXOS (HARDCODED)
  // -------------------------------------------------------------------
  static const List<PlanModel> list = [
    PlanModel(
      id: 'premium',
      nome: 'Passe Premium',
      descricao: 'Para quem ama cinema e quer exclusividade.',
      preco: 49.90,
      beneficios: [
        'Ingressos ilimitados (1 por sessão)',
        'Sem taxas de serviço',
        'Fila preferencial na bomboniere',
      ],
      isPopular: true,
      maxMembros: 1,
    ),
    PlanModel(
      id: 'familia',
      nome: 'Família',
      descricao: 'Diversão garantida para toda a família.',
      preco: 89.90,
      beneficios: [
        'Até 4 pessoas',
        'Todos os benefícios do Premium',
        'Pipoca média grátis mensal',
        'Acesso simultâneo',
      ],
      isPopular: false,
      maxMembros: 4,
    ),
  ];
}
