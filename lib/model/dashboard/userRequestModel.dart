class UserRequest {
  String id;
  String email;
  String approvalStatus;
  String requestedRole;

  UserRequest({
    required this.id,
    required this.email,
    required this.approvalStatus,
    required this.requestedRole,
  });
}