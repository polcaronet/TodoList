enum TaskFilterEnum {
  yesterday,
  today,
  tomorrow,
  week,
  month,
  year,
}

extension TaskFilterEnumExtension
    on TaskFilterEnum {
  String get description {
    switch (this) {
      case TaskFilterEnum.yesterday:
        return 'TASK\'S DE ONTEM';
      case TaskFilterEnum.today:
        return 'TASK\'S DE HOJE';
      case TaskFilterEnum.tomorrow:
        return 'TASK\'S DE AMANHÃ';
      case TaskFilterEnum.week:
        return 'TASK\'S DA SEMANA';
      case TaskFilterEnum.month:
        return 'TASK\'S DO MÊS';
      case TaskFilterEnum.year:
        return 'TASK\'S DO ANO';
    }
  }
}
