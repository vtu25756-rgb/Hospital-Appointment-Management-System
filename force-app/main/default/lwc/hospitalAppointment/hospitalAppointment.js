import { LightningElement } from 'lwc';
import getDoctors from '@salesforce/apex/HospitalAppointmentController.getDoctors';
import createAppointment from '@salesforce/apex/HospitalAppointmentController.createAppointment';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class HospitalAppointment extends LightningElement {

    patientName = '';
    doctorId = '';
    doctors = [];
    appointmentDate = '';
    appointmentTime = '';
    reason = '';

    connectedCallback() {

        getDoctors()
            .then(result => {

                this.doctors = result.map(doctor => {
                    return {
                        label: doctor.Name,
                        value: doctor.Id
                    };
                });

            })
            .catch(error => {

                console.error(
                    'Error loading doctors:',
                    error.body?.message
                );

            });
    }

    handlePatientName(event) {
        this.patientName = event.target.value;
    }

    handleDoctorChange(event) {
        this.doctorId = event.target.value;
    }

    handleAppointmentDate(event) {
        this.appointmentDate = event.target.value;
    }

    handleAppointmentTime(event) {
        this.appointmentTime = event.target.value;
    }

    handleReason(event) {
        this.reason = event.target.value;
    }

    handleBookAppointment() {

        createAppointment({
            patientName: this.patientName,
            doctorId: this.doctorId,
            appointmentDate: this.appointmentDate,
            appointmentTime: this.appointmentTime,
            reason: this.reason
        })

        .then(result => {

            this.showToast(
                'Success',
                'Appointment created successfully. Appointment ID: ' + result,
                'success'
            );

            console.log('Appointment Id:', result);

        })

        .catch(error => {

            console.error(
                'Error message:',
                error.body?.message
            );

            console.error(
                'Full error:',
                JSON.stringify(error)
            );

            let message = 'Something went wrong.';

            if (error.body && error.body.message) {
                message = error.body.message;
            }

            this.showToast(
                'Error',
                message,
                'error'
            );
        });
    }

    showToast(title, message, variant) {

        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });

        this.dispatchEvent(event);
    }
}