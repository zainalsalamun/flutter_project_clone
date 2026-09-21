class UserAccount {
  final String id;
  final String name;
  final String accountNumber;
  final double balance;

  UserAccount({
    required this.id,
    required this.name,
    required this.accountNumber,
    required this.balance,
  });

  // Dummy Data for ABC Mobile Clone
  static UserAccount get dummyData {
    return UserAccount(
      id: 'usr_001',
      name: 'ANDHINI PUTRI',
      accountNumber: '1234567890',
      balance: 100000000.0,
    );
  }
}
