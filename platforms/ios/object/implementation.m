//
//  J2CEntity.m
//  json2code
//
//  Created by json2code on 3/14/14.
//

#import "{{ prefix }}{{ name|capitalize }}.h"

{% for name, property in properties.iteritems() %}
{% if property.type == "string" and property.enum %}
NSDictionary* {{ name }}Dictionary = nil;
{% endif %}
{% endfor %}

@implementation {{ prefix }}{{ name|capitalize }} {
{% for name, property in properties.iteritems() %}
{% if property.type == "string" and property.enum %}
    {{ name|capitalize }} _{{ name }};
{% elif property.type == "string" %}
    NSString* _{{ name }};
{% elif property.type == "number" %}
    NSNumber* _{{ name }};
{% else %}
    {{ prefix }}{{ property.type|capitalize }}* _{{ name }};
{% endif %}
{% endfor %}
}

{% for name, property in properties.iteritems() %}
@synthesize {{ name }} = _{{ name }};
{% endfor %}

+ (void)initialize {
  {% for name, property in properties.iteritems() %}
  {% if property.type == "string" and property.enum %}
  NSArray* {{ name }}KeyArray = [NSArray arrayWithObjects:
  {% for enum_val in property.enum %}
    @"{{ enum_val }}",
  {% endfor %}
  nil];
  NSArray* {{ name }}ObjectArray = [NSArray arrayWithObjects:
  {% for enum_val in property.enum %}
    [NSNumber numberWithInt:{{ enum_val }}],
  {% endfor %}
  nil];
  {{ name }}Dictionary = [NSDictionary dictionaryWithObjects:{{ name }}ObjectArray
                                                         forKeys:{{ name }}KeyArray];

  {% endif %}
  {% endfor %}
}

-(id)initWithDictionary:(NSDictionary *)dict {
  self = [super init];
  if (self != nil) {
{% for name, property in properties.iteritems() %}
{% if name in required %}
    if ([dict valueForKey:@"{{ name }}"] == nil) { 
		[self release];
		return nil;
	}
{% endif %}
    if ([dict valueForKey:@"{{ name }}"]) {
{% if property.type == "string" and property.enum %}
      _{{ name }} = [[{{ name }}Dictionary objectForKey:[dict valueForKey:@"{{ name }}"]] intValue];
{% elif property.type == "string" or property.type == "number" %}
      _{{ name }} = [[dict valueForKey:@"{{ name }}"] copy];
{% else %}
      _{{ name }} = [[{{ prefix }}{{ property.type|capitalize }} alloc] initWithDictionary:[dict valueForKey:@"{{ name }}"]];
{% endif %}
    }
{% endfor %}
  }
  return self;
}

- (void)dealloc {
{% for name, property in properties.iteritems() %}
{% if property.type == "string" and property.enum %}
{% elif property.type == "string" or property.type == "number" %}
    [_{{ name }} release];
{% else %}
    [_{{ name }} release];
{% endif %}
{% endfor %}
    [super dealloc];
}

+({{ prefix }}{{ name|capitalize }}*){{ name|lower }}WithData:(NSData*)data {
    return nil;
}

+(NSData*)dataWith{{ name|capitalize }}:({{ prefix }}{{ name|capitalize }}*){{ name|lower }} {
    
}

- (void)deserialize:(NSData*)data {
  NSError *error = nil;

  id object = [NSJSONSerialization
               JSONObjectWithData:data
               options:0
               error:&error];

  if([object isKindOfClass:[NSDictionary class]])
  {
    NSDictionary* results = object;
    [self initWithDictionary:results];
  }
}

- (NSData*)serialize {
  return nil;
}

@end
