@RestResource(urlMapping='/stripe/webhook')
global class StripeWebhookRest {
    @HttpPost
    global static String handleWebhook() {
        String requestBody = RestContext.request.requestBody.toString();
        String meta;

        try {
            // Desserializa o JSON recebido
            Map<String, Object> payload = (Map<String, Object>) JSON.deserializeUntyped(requestBody);

            // Verifica se o payload contém os campos necessários
            if (payload.containsKey('type') && payload.get('type') == 'checkout.session.completed') {
                if (payload.containsKey('data')) {
                    Map<String, Object> data = (Map<String, Object>) payload.get('data');
                    if (data.containsKey('object')) {
                        Map<String, Object> stripeObject = (Map<String, Object>) data.get('object');

                        // Verifica se o objeto é 'checkout.session' e o pagamento foi concluído
                        if (
                            stripeObject.containsKey('object') &&
                            stripeObject.get('object') == 'checkout.session' &&
                            stripeObject.containsKey('payment_status') &&
                            stripeObject.get('payment_status') == 'paid'
                        ) {
                            // Extrai metadata e URL de pagamento
                            if (stripeObject.containsKey('metadata')) {
                                Map<String, Object> metadata = (Map<String, Object>) stripeObject.get('metadata');
                                String objectId = metadata.containsKey('objectId') ? (String) metadata.get('objectId') : null;
                                String paymentLink = stripeObject.containsKey('payment_link') ? (String) stripeObject.get('payment_link') : null;

                                meta = objectId;

                                // Processa o pagamento baseado no tipo de ID
                                if (objectId != null) {
                                    if (objectId.startsWith('00')) {
                                        updateOpportunityAsPaid(objectId, paymentLink);
                                    } else {
                                        updateBookingAsPaid(objectId, paymentLink);
                                    }
                                }
                            } else {
                                System.debug('Metadata not found in the Stripe object.');
                            }
                        } else {
                            System.debug('Invalid object type or payment status.');
                        }
                    }
                }
            }

            // Retorna um status 200 ao Stripe
            RestContext.response.statusCode = 200;
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
            RestContext.response.statusCode = 400;
            RestContext.response.responseBody = Blob.valueOf('Error: ' + e.getMessage());
            return 'Error: ' + e.getMessage() + ' at line: ' + e.getLineNumber();
        }

        return 'Salesforce has received the data: ' + meta;
    }
    
    private static void updateBookingAsPaid(String bookingId, String paymentLink) {
        if (paymentLink != null && !String.isBlank(paymentLink)) {
            try {
                sugati__Supplier_Booking__c booking = [
                    SELECT Id, Is_Paid_On_Stripe__c
                    FROM sugati__Supplier_Booking__c
                    WHERE Id = :bookingId
                    LIMIT 1
                ];
                booking.Is_Paid_On_Stripe__c = true;
                update booking;
            } catch (Exception e) {
                System.debug('Error updating booking: ' + e.getMessage());
                throw e;
            }
        }
    }
    
    private static void updateOpportunityAsPaid(String opportunityId, String paymentLink) {
        if (paymentLink != null && !String.isBlank(paymentLink)) {
            try {
                Opportunity opportunity = [
                    SELECT Id, Is_Paid_On_Stripe__c
                    FROM Opportunity
                    WHERE Id = :opportunityId
                    LIMIT 1
                ];
                opportunity.Is_Paid_On_Stripe__c = true;
                update opportunity;
            } catch (Exception e) {
                System.debug('Error updating opportunity: ' + e.getMessage());
                throw e;
            }
        }
    }
}