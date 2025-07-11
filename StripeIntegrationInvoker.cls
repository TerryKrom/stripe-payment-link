public with sharing class StripeIntegrationInvoker {
    public class StripePaymentInput {
        @InvocableVariable(label='Booking Id' required=true)
        public Id bookingId;
        
        @InvocableVariable(label='Amount')
        public Decimal amount;
        
        @InvocableVariable(label='Deposit Percentage')
        public Integer depositPercentage;
        
        @InvocableVariable(label='Payment Currency')
        public String paymentCurrency;
    }
    
    @InvocableMethod(label='Create Stripe Payment Link' description='Create a payment link on Stripe for a booking.')
    public static List<String> createPaymentLink(List<StripePaymentInput> inputs) {
        List<String> paymentLinks = new List<String>();
        
        for (StripePaymentInput input : inputs) {
            try {
                // Tratamento explícito para valores não enviados (opcional, só para clareza)
                Decimal amount = input.amount != null ? input.amount : null;
                Integer depositPercentage = input.depositPercentage != null ? input.depositPercentage : null;
                String paymentCurrency = input.paymentCurrency != null ? input.paymentCurrency : null;
                
                // Instanciar a integração e chamar execute com os parâmetros
                StripeIntegration stripeIntegration = new StripeIntegration();
                String paymentLinkUrl = stripeIntegration.execute(
                    input.bookingId,
                amount,
                depositPercentage,
                paymentCurrency
                    );
                
                paymentLinks.add(paymentLinkUrl);
            } catch (Exception e) {
                paymentLinks.add('Error: ' + e.getMessage());
            }
        }
        
        return paymentLinks;
    }
}