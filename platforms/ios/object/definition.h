//
//  J2CEntity.h
//  json2code
//
//  Created by json2code on 3/14/14.
//

#import <Foundation/Foundation.h>

{% for name, property in properties.iteritems() %}
{% if property.type != "string" and property.type != "number" %}
#import "{{ prefix }}{{ name|capitalize }}.h"
{% endif %}
{% endfor %}

@interface {{ prefix }}{{ name|capitalize }} : NSObject

{% for name, property in properties.iteritems() %}
{% if property.type == "string" and property.enum %}
typedef NS_ENUM(NSInteger, {{ name|capitalize }}) {
{% for enum_val in property.enum %}
  {{ enum_val }},
{% endfor %}
};
@property (nonatomic, assign) {{ name|capitalize }} {{ name }};
{% elif property.type == "string" %}
@property (nonatomic, retain) NSString* {{ name }};
{% elif property.type == "number" %}
@property (nonatomic, retain) NSNumber* {{ name }};
{% else %}
@property (nonatomic, retain) {{ prefix }}{{ property.type|capitalize }}* {{ name }};
{% endif %}

{% endfor %}

+({{ prefix }}{{ name|capitalize }}*){{ name|lower }}WithData:(NSData*)data;
+(NSData*)dataWith{{ name|capitalize }}:({{ prefix }}{{ name|capitalize }}*){{ name|lower }};

- (id)initWithDictionary:(NSDictionary*)dict;
- (void)deserialize:(NSData*)data;
- (NSData*)serialize;

@end
