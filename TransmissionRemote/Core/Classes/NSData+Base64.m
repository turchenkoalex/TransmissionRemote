//
//  NSData+Base64.m
//  base64
//

#import "NSData+Base64.h"

static const char *alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

@implementation NSData (Base64)

- (NSString *)encodeToBase64String {
	NSUInteger length = [self length];

	NSUInteger encodedLength = (4 * ((length / 3) + (1 - (3 - (length % 3)) / 3))) + 1;
    char *outputBuffer = malloc(encodedLength);
	unsigned char *inputBuffer = (unsigned char *)[self bytes];
	
	NSUInteger j = 0;
	NSUInteger remain;
    
	for(NSUInteger i = 0; i < length; i += 3) {
		remain = length - i;
		
		outputBuffer[j++] = alphabet[(inputBuffer[i] & 0xFC) >> 2];
		outputBuffer[j++] = alphabet[((inputBuffer[i] & 0x03) << 4) | ((remain > 1) ? ((inputBuffer[i + 1] & 0xF0) >> 4): 0)];
		
		if(remain > 1) {
			outputBuffer[j++] = alphabet[((inputBuffer[i + 1] & 0x0F) << 2) | ((remain > 2) ? ((inputBuffer[i + 2] & 0xC0) >> 6) : 0)];
        } else {
			outputBuffer[j++] = '=';
        }
		if(remain > 2) {
			outputBuffer[j++] = alphabet[inputBuffer[i + 2] & 0x3F];
        } else {
            outputBuffer[j++] = '=';
        }
	}
	
	outputBuffer[j] = 0;
    
    NSString *result =[[NSString alloc] initWithBytes:outputBuffer length:j encoding:NSASCIIStringEncoding];
	free(outputBuffer);
	
	return result;
}

@end
