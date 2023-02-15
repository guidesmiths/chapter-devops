const axios = require('axios')
const { slackChannelWebhookUrl } = require('./config')

module.exports = async (context, req) => {
    let status = "Ok"
    let color = "#00FF00"
    const body = req.body.data.context

    if (req.body.data.status == "Activated") {
        status = "Firing"
        color = "#f2c744"
    }

    const AZBoardUri = body.portalLink
    const alertContent = {
        attachments: [
            {
                color: color,
                blocks: [
                    {
                        type: "section",
                        text: {
                            type: "mrkdwn",
                            text: `<${AZBoardUri} |*[${status}] - ${body.name} in Azure monitoring*>`,
                        }
                    },
                    {
                        type: "section",
                        text: {
                            type: "mrkdwn",
                            text:
`
*Resource Name* : ${body.resourceName}
*Resource Group* : ${body.resourceGroupName}
*Resource Type* : ${body.resourceType}
*Date* : ${body.timestamp}
*Threshold* : ${body.condition.allOf[0].threshold}
*Current value* : ${body.condition.allOf[0].metricValue}
`
                        }
                    },
                ],
            }
        ]
    }
    const response = await axios.post(slackChannelWebhookUrl, alertContent);
    context.log(response);
}
