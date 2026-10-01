public with sharing class HospitalAppointmentController {

    @AuraEnabled(cacheable=true)
    public static List<Doctor__c> getDoctors() {

        return [
            SELECT Id, Name
            FROM Doctor__c
            ORDER BY Name
        ];
    }


    @AuraEnabled
    public static String createAppointment(
        String patientName,
        Id doctorId,
        Date appointmentDate,
        String appointmentTime,
        String reason
    ) {

        Patient__c patient = [
            SELECT Id
            FROM Patient__c
            WHERE Name = :patientName
            LIMIT 1
        ];

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

        appointment.Patient__c = patient.Id;
        appointment.Doctor__c = doctorId;
        appointment.Appointment_Date__c = appointmentDate;
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