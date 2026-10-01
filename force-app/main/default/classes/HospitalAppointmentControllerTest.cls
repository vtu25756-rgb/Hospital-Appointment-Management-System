@isTest
private class HospitalAppointmentControllerTest {

    @isTest
    static void testCreateAppointment() {

        Department__c department = new Department__c(
            Name = 'Test Cardiology'
        );

        insert department;

        Doctor__c doctor = new Doctor__c(
            Name = 'Test Doctor',
            Specialization__c = 'Cardiologist',
            Availability_Status__c = 'Available',
            Department__c = department.Id
        );

        insert doctor;

        Patient__c patient = new Patient__c(
            Name = 'Test Patient'
        );

        insert patient;

        Test.startTest();

        String appointmentId =
            HospitalAppointmentController.createAppointment(
                'Test Patient',
                'Test Doctor',
                Date.today().addDays(1),
                Time.newInstance(10, 0, 0, 0),
                'Test consultation'
            );

        Test.stopTest();

        Appointment__c appointment = [
            SELECT Id, Patient__c, Doctor__c, Status__c
            FROM Appointment__c
            WHERE Id = :appointmentId
        ];

        System.assertEquals(patient.Id, appointment.Patient__c);
        System.assertEquals(doctor.Id, appointment.Doctor__c);
        System.assertEquals('Scheduled', appointment.Status__c);
    }
}