@isTest
private class HospitalAppointmentRestTest {

    @isTest
    static void testCreateAppointment() {

        Doctor__c doctor = new Doctor__c(
            Name = 'REST Test Doctor',
            Specialization__c = 'Cardiologist',
            Availability_Status__c = 'Available'
        );

        insert doctor;

        Patient__c patient = new Patient__c(
            Name = 'REST Test Patient'
        );

        insert patient;

        RestRequest request = new RestRequest();

        request.requestUri =
            '/services/apexrest/hospital/appointment/';

        request.httpMethod = 'POST';

        request.requestBody = Blob.valueOf(
            '{' +
            '"patientId":"' + patient.Id + '",' +
            '"doctorId":"' + doctor.Id + '",' +
            '"appointmentDate":"2026-10-10",' +
            '"appointmentTime":"10:30:00.000Z",' +
            '"reason":"REST API test"' +
            '}'
        );

        RestContext.request = request;

        Test.startTest();

        String result =
            HospitalAppointmentRest.createAppointment();

        Test.stopTest();

        Appointment__c appointment = [
            SELECT Id,
                   Name,
                   Patient__c,
                   Doctor__c,
                   Appointment_Date__c,
                   Appointment_Time__c,
                   Status__c,
                   Reason__c
            FROM Appointment__c
            WHERE Name = :result
            LIMIT 1
        ];

        System.assertEquals(
            patient.Id,
            appointment.Patient__c
        );

        System.assertEquals(
            doctor.Id,
            appointment.Doctor__c
        );

        System.assertEquals(
            Date.newInstance(2026, 10, 10),
            appointment.Appointment_Date__c
        );

        System.assertEquals(
            'Scheduled',
            appointment.Status__c
        );

        System.assertEquals(
            'REST API test',
            appointment.Reason__c
        );
    }
}