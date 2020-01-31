using System.Management.Automation;

namespace Pepitenet.Powershell.SenseHat
{
    public static class RtimuSettings
    {
        public static Sense.RTIMU.RTIMUSettings Settings { get; set; }
    }


    [Cmdlet(VerbsCommon.Set, "SenseHat")]
    public class SetSenseHat : Cmdlet
    {
        protected override void ProcessRecord()
        {
            RtimuSettings.Settings = Sense.RTIMU.RTIMUSettings.CreateDefault();
        }
    }

    [Cmdlet(VerbsCommon.Get, "Humidity")]
    public class GetHumidity : Cmdlet
    {
        protected override void ProcessRecord()
        {
            Sense.RTIMU.RTHumidity Humidity = RtimuSettings.Settings.CreateHumidity();
            Sense.RTIMU.RTHumidityData Result = Humidity.Read();

            WriteObject(Result);
        }
    }

    [Cmdlet(VerbsCommon.Get, "Pressure")]
    public class GetPressure : Cmdlet
    {
        protected override void ProcessRecord()
        {
            Sense.RTIMU.RTPressure Pressure = RtimuSettings.Settings.CreatePressure();
            Sense.RTIMU.RTPressureData Result = Pressure.Read();

            WriteObject(Result);
        }
    }
}
