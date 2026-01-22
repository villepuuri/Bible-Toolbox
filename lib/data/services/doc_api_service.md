=== Documentation for the service data


Meta box

{
"fi": [Map<String, dynamic>]
    {
    "version": 1,
    "lastUpdated": [int, millisecondsSinceEpoch]
    },
...
}

Language box
key: [String]"en"
{
    'data': [List<Map<String, dynamic>>]
        [
            {
                id: [int]
                type: [String]
                title: [String]
                language: [String]
                created: [int, seconds]
                changed: [int, seconds]
                body: [Map<String, dynamic]
                    value: [String]
                    summary: [String]
                taxonomy: [List<Map<String, dynamic>>]
                    [
                        {
                        tid: [int],
                        name: [String],
                        vid: [int],
                        vocabulary: [String]
                        }
                    ]
            },
            ...
        ]       
    'version': [int]
    'lastUpdated': [DateTime, millisecondsSinceEpoch]
}
