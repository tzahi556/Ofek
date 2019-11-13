using Quartz;
using Quartz.Impl;
using System;


public class JobScheduler
{
    public static void Start()
    {
        IScheduler scheduler = StdSchedulerFactory.GetDefaultScheduler();
        scheduler.Start();

        IJobDetail job = JobBuilder.Create<UcontrolJob>().Build();

        ITrigger trigger = TriggerBuilder.Create()
            .WithDailyTimeIntervalSchedule
              (s =>
                 s.WithIntervalInSeconds(50)
                .OnEveryDay()
                .StartingDailyAt(TimeOfDay.HourAndMinuteOfDay(0, 0))
              )
            .Build();

        scheduler.ScheduleJob(job, trigger);
    }
}

public class UcontrolJob : IJob
{
    public void Execute(IJobExecutionContext context)
    {
        WebService SchedularU = new WebService();
        SchedularU.Control_GetAllUConnectSchedular();

    }

}
