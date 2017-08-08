using Ede.Uof.Utility.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;

namespace PochenPOC
{

    //PFJTQUtleVZhbHVlPjxNb2R1bHVzPm5GcHlVa0NhclpnZGVZUEpLeVQ1Wlg1VlpZa3VkZEYyVlJrN2tZTjlnT3RaUGtac3QzcWloT1M5US9zeS9GMUp2MlB0WEVEUFNxdEVZNC8vY2Y0YVFXbVVieHNFMDlSS3gzeTBwN29WcVVBU1B3SEh4UFhkQS9ydUJybFVYT0xMMVlaTDBMY01aUVZsOGs1alFDa3BsV1lhTEZNczRxK3F6VEg1Q1JZK1FnRT08L01vZHVsdXM+PEV4cG9uZW50PkFRQUI8L0V4cG9uZW50PjxQPjBkK2V3Ym1VWEVPdkZmRmZnWm0rN29Na0o1M2xhemtyT1JmcG5qemFWSVJsVWZsQVcwN3VsdE55YzU1K1BEaTRFeTlWUThXTTNJbFBjTS85RDhtL1pRPT08L1A+PFE+dnJlTkRtcisyZWkxcXNMc1NrMnhsTGFHejVPRm9FdS8xUVAvVTM3QW83WDc1OE02VkVkQ1ZCcmdqVnJNZEp5WVJTNnpzcjdidXQ1d2dTK2YyVVowYlE9PTwvUT48RFA+a2VXSm9KU1pEVmJFQlZZSmxiZkNvbDRxS1J3NzIwRWZ5ZzNVaXZzMHIrSmw2UW1EOHJXNWFNSlBZdzdBSks4dFQ3RHM3ak1MekZmc0VMbVY2MzdOZlE9PTwvRFA+PERRPlgzZTJUbTlVMzNQVDdJVGlqMWRRKzJaYkdYRjVSSUptcHBUM3JLNFlkRnJXbkc5bnRXUnVXWGVTekcrVlJSSldUdHRQN0x3SmRnTi9RY3U3TXFKSUNRPT08L0RRPjxJbnZlcnNlUT5BT0x6WC93RmJkSHZwOTNZQ2JIckpKcVBwTmtLdHlWQi9pcnlVS3lVWU8yaWFGdTRtZlFJbWFoUVV4aTF0dTFwNDRYMUVsVTZPclZZb2VlUmxVNWptZz09PC9JbnZlcnNlUT48RD5Ba3JnTkwwSTdPVXNxaUN6ZFNhOURRN1VaVGFrOVZUSUp2akZxR2Ywdkl4c0wwOG5NOEhWcFZ4WTViNHhQSnFJajRqQlRQSTZwOXRlMTJxS2dnc2ZWWkxTcWRIWFVSTTdHbE1CTUFLTUduTUlaajZlZnVjcytnRS9sbkN4V0hIZVJwc3R4SUxtVklscEpNU1BqNzlwMVpFSDU3NSt6anJTQVlmUDJpcHlhNjA9PC9EPjwvUlNBS2V5VmFsdWU+
    public class Authentication
    {
        public string Token { get; set; }
        public string SiteUrl { get; set; }
        string publicKey;
        public Authentication()
        {
            Setting setting = new Setting();
            SiteUrl = setting["SiteUrl"];
            publicKey = "PFJTQUtleVZhbHVlPjxNb2R1bHVzPm5GcHlVa0NhclpnZGVZUEpLeVQ1Wlg1VlpZa3VkZEYyVlJrN2tZTjlnT3RaUGtac3QzcWloT1M5US9zeS9GMUp2MlB0WEVEUFNxdEVZNC8vY2Y0YVFXbVVieHNFMDlSS3gzeTBwN29WcVVBU1B3SEh4UFhkQS9ydUJybFVYT0xMMVlaTDBMY01aUVZsOGs1alFDa3BsV1lhTEZNczRxK3F6VEg1Q1JZK1FnRT08L01vZHVsdXM+PEV4cG9uZW50PkFRQUI8L0V4cG9uZW50PjwvUlNBS2V5VmFsdWU+";
        }

        public string GetToken(string appName, string account, string password)
        {
            //取得登入憑證
            Auth.Authentication auth = new Auth.Authentication();
            auth.Url = SiteUrl + "/PublicAPI/System/Authentication.asmx";
            Token = auth.GetToken(appName, RSAEncrypt(publicKey, account), RSAEncrypt(publicKey, password));

            return Token;
        }

        /// <summary>
        /// RSA 加密
        /// </summary>
        /// <param name="privateKey"></param>
        /// <param name="crTexturlparam>
        /// <returns></returns>
        private static string RSAEncrypt(string publicKey, string crText)
        {

            RSACryptoServiceProvider rsa = new RSACryptoServiceProvider();

            byte[] base64PublicKey = Convert.FromBase64String(publicKey);
            rsa.FromXmlString(System.Text.Encoding.UTF8.GetString(base64PublicKey));


            byte[] ctTextArray = Encoding.UTF8.GetBytes(crText);


            byte[] decodeBs = rsa.Encrypt(ctTextArray, false);

            return Convert.ToBase64String(decodeBs);
        }
    }
}
