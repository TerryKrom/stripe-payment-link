@isTest
private class StripeIntegrationInvokerTest {
    @isTest
    static void testCreatePaymentLink() {
        
        // Criar registros de Brand
        sugati__Brand__c testBrand = new sugati__Brand__c(Name = 'Test Brand');
        insert testBrand;

        // Criar um fornecedor de teste
        sugati__Supplier__c testSupplier = new sugati__Supplier__c(
            Name = 'Test Supplier',
            sugati__S_Email__c = 'test@supplier.com',
            sugati__S_Phone__c = '1234567890'
        );
        insert testSupplier;

        // Criar uma oportunidade de teste
        Opportunity opp = new Opportunity(
            Name = 'Test Opportunity',
            StageName = 'Prospecting',
            CloseDate = Date.today(),
            CurrencyIsoCode = 'USD',
            sugati__O_Return_Date__c = Date.today().addDays(30),
            sugati__O_Service_From_Date__c = Date.today().addDays(10),
            sugati__S_O_Total_Gross_Sell_Price_Selling__c = 1000.0,
            Amount = 5000,
            sugati__O_Agent__c = testSupplier.Id,
            sugati__S_O_Total_Agent_Commission_Due_Booking__c = 150.0,
            sugati__O_Booking_Currency__c = 'USD',
            sugati__O_Brand__c = testBrand.Id
        );
        insert opp;

        // Montar input de teste para a invoker
        StripeIntegrationInvoker.StripePaymentInput input = new StripeIntegrationInvoker.StripePaymentInput();
        input.bookingId = opp.Id;
        input.amount = 4000;
        input.depositPercentage = 20;
        input.paymentCurrency = 'usd';

        List<StripeIntegrationInvoker.StripePaymentInput> inputs = new List<StripeIntegrationInvoker.StripePaymentInput>{ input };

        Test.startTest();
        List<String> result = StripeIntegrationInvoker.createPaymentLink(inputs);
        Test.stopTest();

        // Asserções
        System.assertEquals(1, result.size(), 'Deve retornar um resultado.');
        System.assert(result[0] != null && result[0] != '', 'O link de pagamento não pode ser nulo ou vazio.');
    }
}
