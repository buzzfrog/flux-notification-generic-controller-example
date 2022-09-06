# What do this example do?
This example setups a flux notification controller example with a generic provider. 
This provider subscribe to alerts from a flux source controllers, GitRepository, and Kustomize controller.

# Requirements
* kubectl cli
* kind cli
* flux cli

# How to setup the example
1. Clone this repository
2. Make a fork of https://github.com/stefanprodan/podinfo 
3. Change to your newly created fork in `flux-gitrepository.yaml`
```
spec:
  interval: 30s
  url: https://github.com/<your-user-name>/podinfo
  ref:
    branch: master
```
4. Run `./setup.sh`
5. Wait until cluster is created
6. Find *notification-sink* pod with `kubectl get po`
7. Open the log for that pod with `kubectl logs <pod-name>`

You will get a list of events from GitRepository and Kustomization.
```
info: WebApi1[0]
      {"involvedObject":{"kind":"Kustomization","namespace":"default","name":"podinfo-kust","uid":"46483f17-1c37-4b5a-af9d-6a11f663b81a","apiVersion":"kustomize.toolkit.fluxcd.io/v1beta2","resourceVersion":"819"},"severity":"info","timestamp":"2022-09-06T10:32:18Z","message":"Service/default/podinfo created\nDeployment/default/podinfo created\nHorizontalPodAutoscaler/default/podinfo created","reason":"Progressing","metadata":{"revision":"master/71ea786475aba31c801435d840819f14a2cc0ef2","summary":"notification-sink test cluster"},"reportingController":"kustomize-controller","reportingInstance":"kustomize-controller-65d5dfbf48-dx2zg"}
info: WebApi1[0]
      {"involvedObject":{"kind":"GitRepository","namespace":"default","name":"podinfo","uid":"10bede33-5804-4d9b-b60c-7f038d1c63a5","apiVersion":"source.toolkit.fluxcd.io/v1beta2","resourceVersion":"814"},"severity":"info","timestamp":"2022-09-06T10:32:18Z","message":"stored artifact for commit 'Update deployment.yaml'","reason":"NewArtifact","metadata":{"revision":"master/71ea786475aba31c801435d840819f14a2cc0ef2","summary":"notification-sink test cluster"},"reportingController":"source-controller","reportingInstance":"source-controller-c98cb4b8b-zlkl2"}
```

You can now update your fork repository, commit to master, and see what happens.

# How is the provider notification-sink built?
It is a very simple ASP.NET Core WebApi application.

## Program.cs
```
var builder = WebApplication.CreateBuilder(args);
builder.Logging.ClearProviders();
builder.Logging.AddConsole();

var app = builder.Build();

app.MapPost("/event", (HttpContext context) =>
{
    var str = new StreamReader(context.Request.Body).ReadToEndAsync().Result;
    app.Logger.LogInformation(str);
    context.Response.StatusCode = 201;
}
);

app.Run();
```

# Resources
https://fluxcd.io/flux/guides/notifications/

https://fluxcd.io/flux/components/notification/
