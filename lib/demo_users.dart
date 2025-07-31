/// Demo users for MedTalk app (for seeding and UI selection)
class DemoUser {
  final String id;
  final String name;
  final String role; // 'doctor' or 'patient'
  final String? avatarUrl;

  const DemoUser({required this.id, required this.name, required this.role, this.avatarUrl});
}

const demoDoctors = [
  DemoUser(id: 'doctor_anna', name: 'Dr. Anna Smith', role: 'doctor'),
  DemoUser(id: 'doctor_john', name: 'Dr. John Lee', role: 'doctor'),
  DemoUser(id: 'doctor_emily', name: 'Dr. Emily Wong', role: 'doctor'),
];

const demoPatients = [
  DemoUser(id: 'patient_bob', name: 'Bob Brown', role: 'patient'),
  DemoUser(id: 'patient_jane', name: 'Jane Doe', role: 'patient'),
  DemoUser(id: 'patient_mike', name: 'Mike Green', role: 'patient'),
];
