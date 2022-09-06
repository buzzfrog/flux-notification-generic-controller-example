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
