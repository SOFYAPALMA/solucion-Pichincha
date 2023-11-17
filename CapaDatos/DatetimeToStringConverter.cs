using Newtonsoft.Json;
using System;
using System.Globalization;

namespace CapaDatos
{
    public class DatetimeToStringConverter : JsonConverter
    {
        public override bool CanConvert(Type objectType)
        {
            return objectType == typeof(DateTime?) || objectType == typeof(DateTime);
        }

        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
        {
            if (value == null)
            {
                writer.WriteValue("");
                return;
            }

            DateTime date = (DateTime)value;
            string localDateString = date.ToString("dd/MM/yyyy"); // Usar el formato corto de fecha
            writer.WriteValue(localDateString ?? "");
        }

        public override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
        {
            if (reader?.Value is string dateString)
            {
                return DateTime.Parse(dateString, CultureInfo.CurrentCulture);
            }

            throw new JsonSerializationException($"Cannot deserialize {reader?.Value} to DateTime.");
        }
    }
}
