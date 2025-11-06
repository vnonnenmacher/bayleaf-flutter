// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get welcome => 'Bem-vindo ao CuidaDora';

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
  String get menuBayleaf => 'Dora';

  @override
  String get menuMedications => 'Medicamentos';

  @override
  String get menuAppointments => 'Consultas';

  @override
  String get menuExams => 'Exames';

  @override
  String get menuDoctors => 'Profissionais';

  @override
  String get menuTreatment => 'Tratamento';

  @override
  String get menuOrientations => 'Orientacoes';

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

  @override
  String get vaccinesTabTitle => 'Vacinas';

  @override
  String get vaccinesUpcoming => 'Próximas vacinas';

  @override
  String get vaccinesTaken => 'Vacinas tomadas';

  @override
  String get tooltipAddMedication => 'Adicionar medicamento';

  @override
  String get tooltipAddVaccine => 'Adicionar vacina';

  @override
  String get medicationsLoadError =>
      'Não foi possível carregar os medicamentos. Puxe para atualizar ou tente novamente depois.';

  @override
  String get medicationsNoneTitle => 'Nenhum medicamento ainda';

  @override
  String get medicationsNoneDesc =>
      'Quando seu médico prescrever um medicamento, ele aparecerá aqui.';

  @override
  String get medicationFallback => 'Medicamento';

  @override
  String everyXHours(String hours) {
    return 'A cada ${hours}h';
  }

  @override
  String get asPrescribed => 'Conforme prescrição';

  @override
  String totalUnits(String amount) {
    return 'Total: $amount';
  }

  @override
  String get brandCuidaDora => 'CuidaDora';

  @override
  String get doraHelloTitle => 'Olá, eu sou a Dora';

  @override
  String get doraHelloSubtitle => 'Vou te acompanhar nos primeiros passos.';

  @override
  String get iAmNewHere => 'Eu sou novo aqui';

  @override
  String get iAlreadyHaveAnAccount => 'Eu já possuo uma conta';

  @override
  String get roleDefTitle => 'Escolha seu perfil';

  @override
  String get roleDefSubtitle =>
      'Isso nos ajuda a personalizar a sua experiência.';

  @override
  String get roleDefPatientTitle => 'Eu sigo um tratamento médico';

  @override
  String get roleDefPatientSubtitle =>
      'Preciso de auxílio para organizar meus cuidados.';

  @override
  String get roleDefFamilyTitle => 'Sou familiar ou responsável';

  @override
  String get roleDefFamilySubtitle =>
      'Auxilio um ou mais pacientes nos cuidados.';

  @override
  String get roleDefCaregiverTitle => 'Sou cuidador(a)';

  @override
  String get roleDefCaregiverSubtitle => 'Cuido de um ou mais pacientes.';

  @override
  String get back => 'Voltar';

  @override
  String get acceptTermsOfUse => 'Aceitar os termos de uso da Cuida Dora';

  @override
  String get viewTerms => 'Ver termos de uso.';

  @override
  String get selectPatientTitle => 'Selecione seu paciente';

  @override
  String get selectRelativeTitle => 'Selecione seu familiar';

  @override
  String get addPatient => 'Adicionar paciente';

  @override
  String get noPatientsTitleProfessional => 'Nenhum paciente vinculado';

  @override
  String get noPatientsHintProfessional =>
      'Toque no botão + para adicionar um paciente sob seus cuidados.';

  @override
  String get noPatientsTitleRelative => 'Nenhum familiar vinculado';

  @override
  String get noPatientsHintRelative =>
      'Toque no botão + para adicionar um familiar sob seus cuidados.';

  @override
  String get addPatientComingSoonTitle => 'Adicionar paciente';

  @override
  String get addPatientComingSoonBodyProfessional =>
      'Este recurso estará disponível em breve. Por enquanto, você pode continuar usando o app e selecionar um paciente depois.';

  @override
  String get addPatientComingSoonBodyRelative =>
      'Este recurso estará disponível em breve. Por enquanto, você pode continuar e vincular um familiar depois.';

  @override
  String get ok => 'OK';

  @override
  String get doraChatTitle => 'Conversa com a Dora';

  @override
  String get typeYourMessage => 'Digite sua mensagem...';

  @override
  String get profile_title => 'Perfil';

  @override
  String get profile_edit_title => 'Editar Perfil';

  @override
  String get profile_edit_mode => 'Você agora está editando seu perfil';

  @override
  String get profile_update_success => 'Perfil atualizado com sucesso!';

  @override
  String get profile_update_fail => 'Falha ao atualizar o perfil.';

  @override
  String get profile_tabs_personal => 'Dados pessoais';

  @override
  String get profile_tabs_address => 'Endereço';

  @override
  String get profile_tabs_financial => 'Financeiro';

  @override
  String get profile_first_name => 'Nome';

  @override
  String get profile_last_name => 'Sobrenome';

  @override
  String get profile_date_of_birth => 'Data de Nascimento';

  @override
  String get profile_email => 'E-mail';

  @override
  String get profile_street => 'Rua';

  @override
  String get profile_city => 'Cidade';

  @override
  String get profile_zip => 'CEP';

  @override
  String get profile_state => 'Estado';

  @override
  String get profile_forgot_password => 'Esqueci minha senha';

  @override
  String get profile_logout => 'Sair';

  @override
  String get profile_logout_confirm => 'Tem certeza que deseja sair?';

  @override
  String get profile_financial_placeholder =>
      'Informações financeiras ainda não implementadas.';

  @override
  String get profile_unknown_tab => 'Aba desconhecida selecionada.';
}
