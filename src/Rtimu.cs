using System.Management.Automation;

namespace Pepitenet.Powershell.SenseHat
{
    [Cmdlet(VerbsCommon.Get, "Humidity")]
    public class GetHumidity : Cmdlet
    {
        protected override void ProcessRecord()
        {
            Sense.RTIMU.RTIMUSettings Settings = Sense.RTIMU.RTIMUSettings.CreateDefault();
            Sense.RTIMU.RTHumidity Humidity = Settings.CreateHumidity();
            Sense.RTIMU.RTHumidityData Result = Humidity.Read();

            WriteObject(Result);

        }
    }

    [Cmdlet(VerbsCommon.Get, "Pressure")]
    public class GetPressure : Cmdlet
    {
        protected override void ProcessRecord()
        {
            Sense.RTIMU.RTIMUSettings Settings = Sense.RTIMU.RTIMUSettings.CreateDefault();
            Sense.RTIMU.RTPressure Pressure = Settings.CreatePressure();
            Sense.RTIMU.RTPressureData Result = Pressure.Read();

            WriteObject(Result);
        }
    }
}
