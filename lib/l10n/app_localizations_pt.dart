// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get welcome => 'Bem-vindo ao Bayleaf';

  @override
  String get systemUnavailable =>
      'Nosso sistema está indisponível no momento. Por favor, tente novamente mais tarde.';

  @override
  String get loginFailed => 'Falha no login. Verifique suas credenciais.';

  @override
  String get email => 'E-mail';

  @override
  String get enterEmail => 'Digite o e-mail';

  @override
  String get password => 'Senha';

  @override
  String get minPasswordLength => 'Mínimo de 6 caracteres';

  @override
  String get login => 'Entrar';

  @override
  String get registerPrompt => 'Não tem uma conta? Cadastre-se aqui';

  @override
  String get registrationTitle => 'Crie sua conta';

  @override
  String get firstName => 'Nome';

  @override
  String get enterFirstName => 'Digite o nome';

  @override
  String get lastName => 'Sobrenome';

  @override
  String get enterLastName => 'Digite o sobrenome';

  @override
  String get birthDate => 'Data de nascimento (DD/MM/AAAA)';

  @override
  String get enterBirthDate => 'Digite a data de nascimento';

  @override
  String get register => 'Cadastrar';

  @override
  String get backToLogin => 'Voltar para login';

  @override
  String get invalidBirthDateFormat => 'Formato de data de nascimento inválido';

  @override
  String get menuBayleaf => 'Bayleaf';

  @override
  String get menuMedications => 'Medicamentos';

  @override
  String get menuAppointments => 'Consultas';

  @override
  String get menuExams => 'Exames';

  @override
  String get menuDoctors => 'Profissionais';

  @override
  String get appointmentsUpcoming => 'Próximas';

  @override
  String get appointmentsPast => 'Passadas';

  @override
  String get appointmentsLoading => 'Carregando...';

  @override
  String get appointmentsToday => 'Hoje';

  @override
  String get appointmentsTomorrow => 'Amanhã';

  @override
  String appointmentsInXDays(Object days) {
    return 'Em $days dias';
  }

  @override
  String get appointmentsNoneUpcoming => 'Nenhuma consulta futura';

  @override
  String get appointmentsNoneUpcomingDesc =>
      'Agende sua próxima consulta e cuide da sua saúde.';

  @override
  String get appointmentsNonePast => 'Você ainda não teve consultas';

  @override
  String get appointmentsNonePastDesc =>
      'Assim que concluir uma consulta, ela aparecerá aqui.';

  @override
  String get appointmentsBookAppointment => 'Agendar Consulta';

  @override
  String get appointmentsReschedule => 'Reagendar';

  @override
  String get appointmentsCancel => 'Cancelar';

  @override
  String get appointmentsBookAgain => 'Agendar Novamente';

  @override
  String get appointmentsUnknownDoctor => 'Médico desconhecido';

  @override
  String get appointmentsGeneralPractitioner => 'Clínico Geral';

  @override
  String get appointmentsClinicName => 'Nome da Clínica';

  @override
  String get statusConfirmed => 'Confirmada';

  @override
  String get statusRequested => 'Solicitada';

  @override
  String get statusCancelled => 'Cancelada';
}
