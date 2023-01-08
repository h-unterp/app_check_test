import * as functions from "firebase-functions";

export const helloWorld = functions.runWith({
    enforceAppCheck: true
}).https.onCall((data, context) => {
    functions.logger.info("Hello logs!", { structuredData: true });
    return "Yes";
});