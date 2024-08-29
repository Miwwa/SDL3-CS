using System.Text.Json.Serialization;

namespace GenerateBindings;

internal class RawFFIEntry
{
    [JsonPropertyName("tag")]
    public string Tag { get; }

    [JsonPropertyName("name")]
    public string? Name { get; }

    [JsonPropertyName("location")]
    public string? Header { get; }

    [JsonPropertyName("type")]
    public RawFFIEntry? Type { get; }

    [JsonPropertyName("fields")]
    public RawFFIEntry[]? Fields { get; }

    [JsonPropertyName("value")]
    public uint? Value { get; }

    [JsonPropertyName("parameters")]
    public RawFFIEntry[]? Parameters { get; }

    [JsonPropertyName("return-type")]
    public RawFFIEntry? ReturnType { get; }

    [JsonConstructor]
    public RawFFIEntry(
        string tag,
        string? name,
        string? header,
        RawFFIEntry? type,
        RawFFIEntry[]? fields,
        uint? value,
        RawFFIEntry[]? parameters,
        RawFFIEntry? returnType
    )
    {
        Tag = tag;
        Name = name;
        Header = header;
        Type = type;
        Fields = fields;
        Value = value;
        Parameters = parameters;
        ReturnType = returnType;
    }
}
