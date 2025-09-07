# 💳 Stripe Payment Integration for Salesforce  

## 📌 Overview  
This repository provides a ready-to-use integration between **Salesforce** and **Stripe**.  
It uses **Apex** classes to interact with the **Stripe REST API** and exposes invocable actions to **Salesforce Flows**, making it easy to handle payments without writing extra code.  

---

## ⚙️ Features  
- Create **Payment Links** or **Payment Intents** directly from Salesforce  
- Confirm and retrieve payment status  
- Handle **refunds** through API calls  
- **Webhook endpoint** in Salesforce to receive payment updates from Stripe  
- Test coverage with dedicated Apex test classes  

---

## 🏗️ Project Structure  

| Class | Purpose |
|-------|---------|
| **StripeIntegration.cls** | Core integration logic with Stripe (handles REST calls, authentication, request/response mapping). |
| **StripeService.cls** | Service layer exposing business-friendly methods for payments, refunds, etc. |
| **StripeIntegrationInvoker.cls** | Invocable methods to expose Stripe actions inside Salesforce Flows. |
| **StripeWebhookRest.cls** | REST resource to receive Stripe webhooks (e.g., payment succeeded/failed). |
| **StripeIntegrationTest.cls** | Unit tests for `StripeIntegration`. |
| **StripeServiceTest.cls** | Unit tests for `StripeService`. |
| **StripeIntegrationInvokerTest.cls** | Unit tests for Flow invocable methods. |

---

## 🚀 Setup Instructions  

### 1. Stripe Setup  
1. Sign up for a [Stripe Account](https://dashboard.stripe.com/).  
2. Get your **Secret Key** from the Stripe dashboard.  
3. (Optional) Enable **Test Mode** for sandbox transactions.  

### 2. Salesforce Setup  
1. Add your **Stripe Secret Key** in Salesforce:  
   - Either via **Custom Metadata** or **Named Credentials**.  
2. Deploy the Apex classes from this repo.  
3. Assign proper permissions for users running Flows with Stripe actions.  

### 3. Flow Usage  
Available Invocable Actions (via `StripeIntegrationInvoker`):  
- **Create Payment Link**  
- **Retrieve Payment Status**  
- **Refund Payment**  

Admins can drag-and-drop these actions into Flows and map input/output variables.

---

## 🌐 Webhook Handling  
The class `StripeWebhookRest.cls` acts as a REST endpoint to capture Stripe events.  
Steps:  
1. Expose the endpoint via a **Salesforce Site** or **Experience Cloud Site**.  
2. Configure the endpoint URL in your Stripe Dashboard → Webhooks.  
3. Handle events like `payment_intent.succeeded` or `payment_intent.payment_failed`.  

---

## 🧪 Testing  
All core classes have unit tests:  
- Run `StripeIntegrationTest`, `StripeServiceTest`, `StripeIntegrationInvokerTest` to validate behavior.  
- Use **Stripe Test Keys** to simulate real-world transactions.  
- Debug results in Salesforce logs + Stripe Dashboard.  

---

## 📊 Example Flow  
Example: **Checkout Flow**  
1. User triggers Flow → Flow calls `Create Payment Link`.  
2. Stripe generates a hosted payment page URL.  
3. Flow updates Salesforce record with link → User completes payment.  
4. Webhook updates Salesforce with final status.  

---

## 🔮 Future Enhancements  
- Expand support for **Subscriptions / Recurring Payments**  
- Advanced error handling with **Custom Error Objects**  
- Enhanced webhook handling for more Stripe event types  

---

## 📚 References  
- [Stripe API Documentation](https://stripe.com/docs/api)  
- [Salesforce Apex Callouts](https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_callouts.htm)  
- [Salesforce Flows](https://help.salesforce.com/s/articleView?id=sf.flow_build.htm)  
