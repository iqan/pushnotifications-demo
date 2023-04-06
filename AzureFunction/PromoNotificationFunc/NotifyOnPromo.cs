using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.Azure.NotificationHubs;
using Microsoft.Azure.WebJobs;
using Microsoft.Extensions.Logging;

namespace PromoNotificationFunc
{
    public static class NotifyOnPromo
    {
        [FunctionName(nameof(NotifyOnPromo))]
        public static async Task Run([CosmosDBTrigger(
            databaseName: "iqans-demo-cosmos-db",
            containerName: "promo",
            Connection = "CosmosDBConnection",
            LeaseContainerName = "leases")]IReadOnlyList<PromoItem> input, ILogger log)
        {
            if (input != null && input.Count > 0)
            {
                log.LogInformation("Documents modified " + input.Count);
                var promoText = input[0].text;
                log.LogInformation("Promo Title " + input[0].title);
                log.LogInformation("Promo Text " + promoText);

                var connectionString = "<PUT YOUR NOTIFICATION HUB CONNECTION STRING HERE>";
                var hubName = "iqans-demos-notificationhub";
                var nhClient = NotificationHubClient.CreateClientFromConnectionString(connectionString, hubName);

                var notificationPayload = "{\"data\":{\"body\":\"" + promoText + "\",\"title\":\"" + input[0].title + "\"}}";
                var notification = new FcmNotification(notificationPayload);

                var outcomeFcmByTag = await nhClient.SendFcmNativeNotificationAsync(notificationPayload);
            }
        }
    }

    public class PromoItem
    {
        public string title { get; set; }
        public string text { get; set; }
    }
}
