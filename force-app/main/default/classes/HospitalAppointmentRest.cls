@RestResource(urlMapping='/hospital/appointment/*')
global with sharing class HospitalAppointmentRest {

    @HttpPost
    global static String createAppointment() {

        String requestBody = RestContext.request.requestBody.toString();

        Map<String, Object> data =
            (Map<String, Object>) JSON.deserializeUntyped(requestBody);

        String patientId = (String) data.get('patientId');
        String doctorId = (String) data.get('doctorId');
        String appointmentDate = (String) data.get('appointmentDate');
        String appointmentTime = (String) data.get('appointmentTime');
        String reason = (String) data.get('reason');

        List<String> timeParts = appointmentTime.split(':');

        Integer hours = Integer.valueOf(timeParts[0]);
        Integer minutes = Integer.valueOf(timeParts[1]);

        Time selectedTime = Time.newInstance(
            hours,
            minutes,
            0,
            0
        );

        Appointment__c appointment = new Appointment__c();

        appointment.Patient__c = patientId;
        appointment.Doctor__c = doctorId;
        appointment.Appointment_Date__c =
            Date.valueOf(appointmentDate);
        appointment.Appointment_Time__c = selectedTime;
        appointment.Status__c = 'Scheduled';
        appointment.Reason__c = reason;

        insert appointment;

        Appointment__c savedAppointment = [
            SELECT Name
            FROM Appointment__c
            WHERE Id = :appointment.Id
            LIMIT 1
        ];

        return savedAppointment.Name;
    }
}