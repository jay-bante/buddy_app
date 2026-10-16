# Authored, offline content. Each language row: prompt | 4 options | explanation.
# This file generates lib/game/questions.dart; no translation/network service is used.
DATA=[]
def q(id,level,audience,en,hi,mr):
    rows=[s.split('|') for s in (en,hi,mr)]
    assert all(len(r)==6 for r in rows),id
    DATA.append(dict(id=id,level=level,audience=audience,rows=rows))
q('space','low','all',
'A distant tiger is crossing the path. What should you do?|Give it space; do not follow.|Run after it.|Block the path.|Call it closer.|Let wildlife pass without following or blocking it.',
'दूर एक बाघ रास्ता पार कर रहा है। क्या करें?|उसे जगह दें; पीछा न करें।|उसके पीछे दौड़ें।|रास्ता रोकें।|उसे पास बुलाएँ।|वन्यजीव को बिना पीछा किए या रोके निकलने दें।',
'दूर एक वाघ वाट ओलांडत आहे. काय कराल?|त्याला जागा द्या; पाठलाग नको.|त्याच्यामागे धावा.|वाट अडवा.|त्याला जवळ बोलवा.|वन्यजीवाला न अडवता किंवा पाठलाग न करता जाऊ द्या.')
q('cubs','low','all',
'You notice tiger cubs. No adult is visible. What now?|Keep away and tell your guide.|Touch a cub.|Offer food.|Wait beside them.|An adult may be nearby. Never approach or handle cubs.',
'बाघ के बच्चे दिखे, बड़ा बाघ नहीं दिखा। अब क्या?|दूर रहें और गाइड को बताएँ।|बच्चे को छुएँ।|खाना दें।|उनके पास रुकें।|बड़ा बाघ पास हो सकता है। बच्चों के पास न जाएँ, न छुएँ।',
'वाघाची पिल्ले दिसली; मोठा वाघ दिसत नाही. काय कराल?|दूर राहा आणि मार्गदर्शकाला सांगा.|पिल्लाला स्पर्श करा.|खायला द्या.|त्यांच्याजवळ थांबा.|मोठा वाघ जवळ असू शकतो. पिल्लांजवळ जाऊ नका, हाताळू नका.')
q('food','low','all',
'A visitor offers food to attract wildlife. Your choice?|Do not feed or lure animals.|Add more food.|Feed by hand.|Hide food on the trail.|Feeding can change behaviour and create conflict.',
'कोई वन्यजीव को बुलाने के लिए खाना देता है। आपकी पसंद?|जानवर को खाना देकर न बुलाएँ।|और खाना दें।|हाथ से खिलाएँ।|राह पर खाना छिपाएँ।|खिलाने से व्यवहार बदल सकता है और टकराव बढ़ सकता है।',
'कोणी वन्यजीवाला बोलवण्यासाठी अन्न देत आहे. तुमची निवड?|अन्न देऊन प्राण्याला बोलावू नका.|आणखी अन्न द्या.|हाताने भरवा.|वाटेवर अन्न लपवा.|खाऊ घातल्याने वर्तन बदलू शकते आणि संघर्ष वाढू शकतो.')
q('vehicle','low','all',
'A tiger rests near your safari vehicle. What is appropriate?|Stay inside; listen to the guide.|Step out for a photo.|Reach towards it.|Climb onto the roof.|Remain in the vehicle unless authorised staff permit exit.',
'सफारी वाहन के पास बाघ आराम कर रहा है। क्या सही है?|अंदर रहें; गाइड की सुनें।|फोटो के लिए उतरें।|उसकी ओर हाथ बढ़ाएँ।|छत पर चढ़ें।|अधिकृत कर्मचारी अनुमति न दें तो वाहन में ही रहें।',
'सफारी वाहनाजवळ वाघ विश्रांती घेत आहे. काय योग्य आहे?|आत राहा; मार्गदर्शकाचे ऐका.|फोटोसाठी उतरा.|त्याच्याकडे हात न्या.|छतावर चढा.|अधिकृत कर्मचारी परवानगी देत नाहीत तोवर वाहनातच राहा.')
q('litter','low','all',
'You have an empty snack wrapper. Where should it go?|Carry it to an authorised bin.|Under a stone.|Into the stream.|Behind a tree.|Carry waste back or use designated facilities.',
'नाश्ते का खाली पैकेट है। कहाँ रखें?|निर्धारित कूड़ेदान तक ले जाएँ।|पत्थर के नीचे।|धारा में।|पेड़ के पीछे।|कचरा वापस ले जाएँ या निर्धारित सुविधा का उपयोग करें।',
'खाऊचे रिकामे पाकीट आहे. कुठे टाकाल?|ठरवलेल्या कचरापेटीपर्यंत न्या.|दगडाखाली.|ओढ्यात.|झाडामागे.|कचरा परत न्या किंवा ठरवलेली सुविधा वापरा.')
q('closed','low','all',
'A ranger has closed a trail. What should you do?|Use an authorised alternative.|Cross the barrier.|Follow footprints past it.|Go when nobody looks.|Current local restrictions must be respected.',
'वनरक्षक ने रास्ता बंद किया है। क्या करें?|अनुमत दूसरा रास्ता लें।|रोक पार करें।|पैरों के निशान के पीछे जाएँ।|चुपके से निकलें।|वर्तमान स्थानीय प्रतिबंधों का पालन करें।',
'वनरक्षकाने वाट बंद केली आहे. काय कराल?|अधिकृत दुसरी वाट घ्या.|अडथळा ओलांडा.|पावलांच्या खुणांमागे जा.|कोणी पाहत नसताना जा.|सध्याचे स्थानिक निर्बंध पाळा.')
q('quiet','low','all',
'From a vehicle, you watch an undisturbed tiger. What is respectful?|Watch quietly with the guide.|Shout for attention.|Play animal calls.|Bang on the vehicle.|Do not disturb a calm safari sighting. Emergency situations differ.',
'वाहन से शांत बाघ देख रहे हैं। सम्मानजनक व्यवहार क्या है?|गाइड के साथ चुपचाप देखें।|ध्यान खींचने को चिल्लाएँ।|जानवरों की आवाज़ चलाएँ।|वाहन पर चोट करें।|शांत सफारी दृश्य में बाधा न डालें। आपात स्थिति अलग होती है।',
'वाहनातून शांत वाघ पाहत आहात. आदराने कसे वागाल?|मार्गदर्शकासोबत शांतपणे पाहा.|लक्ष वेधण्यासाठी ओरडा.|प्राण्यांचे आवाज वाजवा.|वाहनावर आपटा.|शांत सफारी दर्शनात व्यत्यय आणू नका. आपत्कालीन प्रसंग वेगळे असतात.')
q('resting','low','all',
'A wild tiger looks calm. What does that mean?|It still needs distance.|It is safe to touch.|It is tame.|It cannot react quickly.|A calm appearance is not permission to approach.',
'जंगली बाघ शांत दिखता है। इसका क्या अर्थ है?|फिर भी दूरी ज़रूरी है।|उसे छूना सुरक्षित है।|वह पालतू है।|वह जल्दी प्रतिक्रिया नहीं देगा।|शांत दिखना पास जाने की अनुमति नहीं है।',
'जंगली वाघ शांत दिसतो. याचा अर्थ काय?|तरीही अंतर ठेवणे गरजेचे आहे.|स्पर्श करणे सुरक्षित आहे.|तो पाळीव आहे.|तो पटकन प्रतिक्रिया देणार नाही.|शांत दिसणे म्हणजे जवळ जाण्याची परवानगी नाही.')
q('photo','medium','all',
'Your phone cannot capture a distant tiger clearly. Which priority matters more?|Keep distance; accept a smaller photo.|Move closer for detail.|Ask the driver to chase it.|Step off the route quietly.|Respecting wildlife matters more than getting a photograph.',
'दूर के बाघ का फोटो साफ नहीं आता। क्या अधिक ज़रूरी है?|दूरी रखें; छोटा फोटो स्वीकारें।|विवरण के लिए पास जाएँ।|चालक से पीछा करवाएँ।|चुपचाप रास्ता छोड़ें।|फोटो से अधिक महत्वपूर्ण वन्यजीव का सम्मान है।',
'दूरच्या वाघाचा फोटो स्पष्ट येत नाही. काय जास्त महत्त्वाचे?|अंतर ठेवा; छोटा फोटो स्वीकारा.|तपशीलासाठी जवळ जा.|चालकाला पाठलाग करायला सांगा.|हळूच वाट सोडा.|फोटोपेक्षा वन्यजीवाचा आदर महत्त्वाचा आहे.')
q('tracks','medium','all',
'Fresh tracks leave your approved route. Your friend wants to follow. What do you choose?|Tell the guide and stay on the route.|Follow together.|Follow alone to reduce noise.|Search the bushes nearby.|Tracks are information for the guide, not permission to track a tiger.',
'ताज़े निशान अनुमत राह से बाहर जाते हैं। दोस्त पीछा करना चाहता है। क्या चुनें?|गाइड को बताएँ; राह पर रहें।|साथ में पीछा करें।|कम शोर के लिए अकेले जाएँ।|पास की झाड़ियाँ खोजें।|निशान गाइड के लिए सूचना हैं, बाघ का पीछा करने की अनुमति नहीं।',
'ताज्या खुणा अधिकृत वाटेबाहेर जातात. मित्र पाठलाग करू इच्छितो. काय निवडाल?|मार्गदर्शकाला सांगा; वाटेवर राहा.|एकत्र पाठलाग करा.|आवाज कमी होईल म्हणून एकटे जा.|जवळची झुडपे शोधा.|खुणा म्हणजे मार्गदर्शकासाठी माहिती, वाघाचा माग काढण्याची परवानगी नाही.')
q('injured','medium','all',
'A tiger appears injured. You want to help. What is the appropriate first step?|Keep away and alert wildlife staff.|Offer water by hand.|Try to touch its leg.|Gather a crowd around it.|Compassion means getting trained help without approaching.',
'बाघ घायल लगता है। आप मदद करना चाहते हैं। पहला सही कदम?|दूर रहकर वन कर्मचारियों को बताएँ।|हाथ से पानी दें।|उसका पैर छुएँ।|उसके आसपास भीड़ बुलाएँ।|करुणा का अर्थ पास गए बिना प्रशिक्षित मदद बुलाना है।',
'वाघ जखमी वाटतो. तुम्हाला मदत करायची आहे. पहिले योग्य पाऊल?|दूर राहून वन कर्मचाऱ्यांना सांगा.|हाताने पाणी द्या.|त्याच्या पायाला हात लावा.|त्याच्याभोवती गर्दी जमवा.|जवळ न जाता प्रशिक्षित मदत मिळवणे हीच योग्य मदत आहे.')
q('group','medium','all',
'A tiger is nearby. Someone suggests scattering to distract it. What is better?|Stay together and follow the guide.|Run in different directions.|Send one person closer.|Leave someone behind.|Do not scatter or run. Follow trained local directions.',
'बाघ पास है। कोई ध्यान भटकाने के लिए बिखरने को कहता है। बेहतर क्या है?|साथ रहें और गाइड की सुनें।|अलग दिशाओं में दौड़ें।|एक व्यक्ति पास भेजें।|किसी को पीछे छोड़ें।|बिखरें या दौड़ें नहीं। प्रशिक्षित स्थानीय निर्देश मानें।',
'वाघ जवळ आहे. लक्ष विचलित करण्यासाठी पांगावे असे कोणी म्हणते. योग्य काय?|एकत्र राहा; मार्गदर्शकाचे ऐका.|वेगवेगळ्या दिशांना धावा.|एकाला जवळ पाठवा.|कोणाला मागे सोडा.|पांगू नका किंवा धावू नका. प्रशिक्षित स्थानिक निर्देश पाळा.')
q('report','medium','all',
'You are safely away after a sighting. Which report is most useful?|Time, place, behaviour and direction.|A dramatic guess about its mood.|Only a blurry photo.|A claim that all tigers are tame.|Report observed facts rather than guessing intentions.',
'दर्शन के बाद आप सुरक्षित दूर हैं। कौन सी सूचना सबसे उपयोगी है?|समय, स्थान, व्यवहार और दिशा।|उसके मूड का नाटकीय अनुमान।|केवल धुंधला फोटो।|सभी बाघ पालतू हैं, यह दावा।|इरादे का अनुमान लगाने के बजाय देखे हुए तथ्य बताएँ।',
'दर्शनानंतर तुम्ही सुरक्षित दूर आहात. कोणती माहिती उपयुक्त?|वेळ, ठिकाण, वर्तन आणि दिशा.|त्याच्या मनःस्थितीचा अंदाज.|फक्त अस्पष्ट फोटो.|सगळे वाघ पाळीव असल्याचा दावा.|हेतूचा अंदाज न लावता पाहिलेली तथ्ये सांगा.')
q('carcass','medium','all',
'A fresh carcass lies beside a shortcut. Which route should you prefer?|Avoid it and consult the guide.|Pass close to inspect it.|Wait beside it for wildlife.|Move it off the path.|A predator may be nearby or return. Do not approach a kill.',
'छोटे रास्ते के पास ताज़ा शव है। कौन सी राह चुनें?|उससे बचें और गाइड से पूछें।|जाँचने के लिए पास जाएँ।|वन्यजीव के लिए वहीं रुकें।|उसे रास्ते से हटाएँ।|शिकारी पास हो सकता है या लौट सकता है। शिकार के पास न जाएँ।',
'जवळच्या वाटेवर ताजे मृत जनावर आहे. कोणती वाट निवडाल?|ते टाळा आणि मार्गदर्शकाला विचारा.|तपासण्यासाठी जवळ जा.|वन्यजीवासाठी तिथे थांबा.|ते वाटेवरून हलवा.|शिकारी जवळ असू शकतो किंवा परत येऊ शकतो. शिकारीजवळ जाऊ नका.')
q('notseen','medium','all',
'Your visit is ending without a tiger sighting. What is responsible?|Leave on time; sightings are not guaranteed.|Ask the guide to bait a tiger.|Stay after closing.|Search alone on foot.|Respect access times rather than chasing a guaranteed sighting.',
'यात्रा समाप्त हो रही है, बाघ नहीं दिखा। जिम्मेदार निर्णय?|समय पर लौटें; दर्शन तय नहीं हैं।|गाइड से चारा रखने को कहें।|बंद होने के बाद रुकें।|अकेले पैदल खोजें।|निश्चित दर्शन के लिए पीछा करने के बजाय समय का पालन करें।',
'भेट संपत आली; वाघ दिसला नाही. जबाबदार निर्णय?|वेळेत परता; दर्शनाची हमी नसते.|मार्गदर्शकाला आमिष ठेवायला सांगा.|वेळ संपल्यावरही थांबा.|एकटे पायी शोधा.|दर्शनासाठी पाठलाग न करता प्रवेशाच्या वेळा पाळा.')
q('blocked','medium','all',
'Vehicles are crowding around a tiger. What should you support?|Guide-managed spacing and an open exit.|A tighter circle for photos.|Blocking both ends of the road.|Getting out to direct it.|Wildlife needs an unobstructed way out, not an audience barrier.',
'वाहन बाघ के आसपास जमा हैं। किस बात का समर्थन करें?|गाइड के अनुसार दूरी और खुला रास्ता।|फोटो के लिए घेरा छोटा करें।|सड़क के दोनों सिरे रोकें।|उतरकर उसे दिशा दें।|वन्यजीव को निकलने का खुला रास्ता चाहिए, दर्शकों की दीवार नहीं।',
'वाघाभोवती वाहने जमा झाली आहेत. कशाला पाठिंबा द्याल?|मार्गदर्शकानुसार अंतर आणि खुली वाट.|फोटोसाठी आणखी घट्ट घेरा.|रस्त्याची दोन्ही टोके अडवा.|उतरून त्याला दिशा द्या.|वन्यजीवाला बाहेर पडण्याची मोकळी वाट हवी, प्रेक्षकांची भिंत नव्हे.')
q('evidence','high','all',
'An old map says open; a ranger says closed after a sighting. Which evidence should guide your choice?|Current ranger instructions.|The map because it is printed.|The shortest distance alone.|A stranger who has not checked.|Current authorised information outweighs outdated route information.',
'पुराने नक्शे में राह खुली है; दर्शन के बाद वनरक्षक ने बंद कहा। किस सूचना पर निर्णय लें?|वनरक्षक के वर्तमान निर्देश।|छपा होने से पुराना नक्शा।|केवल सबसे छोटी दूरी।|बिना जाँच वाले अजनबी की बात।|वर्तमान अधिकृत जानकारी पुरानी मार्ग सूचना से अधिक महत्वपूर्ण है।',
'जुन्या नकाशात वाट खुली; दर्शनानंतर वनरक्षक बंद म्हणतो. कोणती माहिती वापराल?|वनरक्षकाचे सध्याचे निर्देश.|छापील असल्याने जुना नकाशा.|फक्त सर्वात कमी अंतर.|तपासणी न केलेल्या अनोळखीचे मत.|सध्याची अधिकृत माहिती जुन्या मार्गमाहितीपेक्षा महत्त्वाची आहे.')
q('uncertain','high','all',
'A tiger vanishes into cover. You cannot tell where it went. What does uncertainty imply?|Do not follow; consult the guide.|The area must now be safe.|It wants you to follow.|You should search every bush.|Not seeing an animal is not evidence that approaching is safe.',
'बाघ झाड़ियों में ओझल है। दिशा पता नहीं। इस अनिश्चितता का क्या अर्थ है?|पीछा न करें; गाइड से पूछें।|जगह अब ज़रूर सुरक्षित है।|वह चाहता है आप पीछे आएँ।|हर झाड़ी में खोजें।|जानवर न दिखना, पास जाना सुरक्षित होने का प्रमाण नहीं है।',
'वाघ झुडपात दिसेनासा झाला. दिशा माहीत नाही. अनिश्चिततेचा अर्थ काय?|पाठलाग नको; मार्गदर्शकाला विचारा.|जागा आता नक्की सुरक्षित आहे.|त्याला तुम्ही मागे यावे वाटते.|प्रत्येक झुडपात शोधा.|प्राणी दिसत नाही म्हणजे जवळ जाणे सुरक्षित आहे असा पुरावा नाही.')
q('tradeoff','high','all',
'A shortcut saves time but leaves the permitted route. The longer route is authorised. Which matters most?|Permission and safety, not saved time.|Time saved above all else.|Whether friends will follow.|Whether anyone can see you.|Do not trade away access rules for convenience.',
'छोटी राह समय बचाती है पर अनुमत मार्ग से बाहर है। लंबी राह अधिकृत है। क्या सबसे ज़रूरी?|अनुमति और सुरक्षा, केवल समय नहीं।|हर चीज़ से अधिक समय बचाना।|दोस्त साथ आएँगे या नहीं।|कोई देख रहा है या नहीं।|सुविधा के लिए प्रवेश नियमों से समझौता न करें।',
'जवळची वाट वेळ वाचवते पण परवानगीबाहेर आहे. लांब वाट अधिकृत आहे. महत्त्वाचे काय?|परवानगी आणि सुरक्षा, फक्त वेळ नव्हे.|कशाहीपेक्षा वेळ वाचवणे.|मित्र येतील की नाही.|कोणी पाहत आहे की नाही.|सोयीसाठी प्रवेशाच्या नियमांशी तडजोड करू नका.')
q('sequence','high','all',
'You notice a wildlife hazard while still nearby. Which sequence makes sense?|Reach safety with the guide, then report facts.|Stop beside it to post online.|Approach first, then ask advice.|Gather spectators, then leave.|Do not delay safe distancing to document or publicise a hazard.',
'पास रहते हुए वन्यजीव का खतरा दिखा। उचित क्रम क्या है?|गाइड संग सुरक्षित जाएँ, फिर तथ्य बताएँ।|पास रुककर ऑनलाइन पोस्ट करें।|पहले पास जाएँ, फिर सलाह लें।|दर्शक बुलाएँ, फिर जाएँ।|खतरे का प्रचार या रिकॉर्ड करने के लिए सुरक्षित दूरी बनाने में देर न करें।',
'जवळ असताना वन्यजीवाचा धोका दिसला. योग्य क्रम कोणता?|मार्गदर्शकासोबत सुरक्षित जा, मग तथ्ये सांगा.|जवळ थांबून ऑनलाइन पोस्ट करा.|आधी जवळ जा, मग सल्ला घ्या.|प्रेक्षक जमवा, मग जा.|धोका नोंदवण्यासाठी किंवा प्रसिद्धीसाठी सुरक्षित अंतर ठेवण्यास उशीर करू नका.')
q('notuniversal','high','all',
'A game says one action always works with tigers. How should you judge that claim?|Reject the guarantee; situations differ.|Trust it because it is a game.|Try it on the next tiger.|Apply it to every animal.|No game can guarantee an outcome in a real wildlife encounter.',
'खेल कहता है एक उपाय बाघ पर हमेशा काम करता है। इस दावे को कैसे परखें?|गारंटी न मानें; स्थितियाँ अलग होती हैं।|खेल है इसलिए भरोसा करें।|अगले बाघ पर आज़माएँ।|हर जानवर पर लागू करें।|असली वन्यजीव सामना कैसा होगा, कोई खेल गारंटी नहीं दे सकता।',
'खेळ म्हणतो वाघासाठी एक कृती नेहमीच चालते. दावा कसा तपासाल?|हमी नाकारा; परिस्थिती बदलते.|खेळ आहे म्हणून विश्वास ठेवा.|पुढच्या वाघावर करून पाहा.|प्रत्येक प्राण्यासाठी वापरा.|खऱ्या वन्यजीव भेटीच्या परिणामाची हमी कोणताही खेळ देऊ शकत नाही.')
q('distanceclaim','high','all',
'A visitor quotes a distance rule from another reserve. Your guide requires more space here. What takes priority?|This reserve’s current instructions.|The smaller quoted number.|Whatever fits the photograph.|The loudest visitor’s opinion.|Do not treat a rule from another location as universal.',
'कोई दूसरे अभयारण्य की दूरी बताता है। यहाँ गाइड अधिक दूरी कहता है। प्राथमिकता किसे?|इस अभयारण्य के वर्तमान निर्देश।|बताई गई छोटी संख्या।|फोटो के अनुसार दूरी।|सबसे ऊँची आवाज़ वाले की राय।|दूसरी जगह का नियम हर जगह लागू नहीं होता।',
'कोणी दुसऱ्या अभयारण्याचे अंतर सांगते. इथे मार्गदर्शक अधिक अंतर सांगतो. प्राधान्य कशाला?|या अभयारण्याचे सध्याचे निर्देश.|सांगितलेला लहान आकडा.|फोटोला योग्य अंतर.|मोठ्याने बोलणाऱ्याचे मत.|दुसऱ्या ठिकाणचा नियम सर्वत्र लागू समजू नका.')
q('pressure','high','all',
'Everyone wants a closer view, but the guide says it would crowd the tiger. What is the sound decision?|Support space despite group pressure.|Vote to overrule the guide.|Approach because most people agree.|Take turns getting close.|A majority preference does not remove a wildlife risk.',
'सब पास से देखना चाहते हैं, पर गाइड कहता है बाघ घिर जाएगा। सही निर्णय?|दबाव के बावजूद दूरी का समर्थन करें।|मतदान से गाइड को रोकें।|अधिकतर सहमत हैं तो पास जाएँ।|बारी-बारी पास जाएँ।|बहुमत की इच्छा से वन्यजीव का खतरा नहीं मिटता।',
'सर्वांना जवळून पाहायचे, पण वाघ घेरला जाईल असे मार्गदर्शक सांगतो. योग्य निर्णय?|दबाव असूनही अंतराला पाठिंबा द्या.|मतदानाने मार्गदर्शकाला नाकारा.|बहुमत आहे म्हणून जवळ जा.|आळीपाळीने जवळ जा.|बहुमताची इच्छा वन्यजीवाचा धोका दूर करत नाही.')
q('quietcontext','high','all',
'Quiet viewing suits an undisturbed safari sighting. Can you apply it to every emergency?|No; context and trained advice matter.|Yes; every encounter is identical.|Yes; animals never react differently.|Ignore all local advice.|Advice for calm viewing is not a universal emergency response.',
'शांत सफारी दर्शन में चुप रहना सही है। क्या हर आपात स्थिति में यही लागू है?|नहीं; स्थिति और प्रशिक्षित सलाह ज़रूरी हैं।|हाँ; हर सामना एक जैसा है।|हाँ; जानवर हमेशा एक जैसे रहते हैं।|सारी स्थानीय सलाह छोड़ें।|शांत दर्शन की सलाह हर आपात स्थिति का एक ही उत्तर नहीं है।',
'शांत सफारी दर्शनात शांत राहणे योग्य. प्रत्येक आपत्कालीन प्रसंगात तेच लागू का?|नाही; परिस्थिती आणि प्रशिक्षित सल्ला महत्त्वाचा.|हो; प्रत्येक भेट सारखीच असते.|हो; प्राणी वेगळे वागतच नाहीत.|सर्व स्थानिक सल्ला दुर्लक्षित करा.|शांत दर्शनाचा सल्ला हा प्रत्येक आपत्कालीन प्रसंगाचा एकच उपाय नाही.')
# Profile-specific opening scenarios. Difficulty is independent of age.
q('child_low','low','child',
'On a guided family visit, you see tiger tracks. Who should you tell?|Your trusted adult and guide.|Nobody; follow alone.|Only a toy animal.|A friend far away.|Stay with your trusted adult and guide; do not follow tracks.',
'परिवार की निर्देशित यात्रा में बाघ के निशान दिखे। किसे बताएँ?|अपने भरोसेमंद बड़े और गाइड को।|किसी को नहीं; अकेले जाएँ।|सिर्फ खिलौने को।|दूर के दोस्त को।|भरोसेमंद बड़े और गाइड के साथ रहें; निशानों का पीछा न करें।',
'कुटुंबाच्या मार्गदर्शित भेटीत वाघाच्या खुणा दिसल्या. कोणाला सांगाल?|विश्वासू मोठ्या व्यक्तीला आणि मार्गदर्शकाला.|कोणालाही नाही; एकटे जा.|फक्त खेळण्याला.|दूरच्या मित्राला.|विश्वासू मोठ्या व्यक्तीसोबत आणि मार्गदर्शकासोबत राहा; खुणांचा पाठलाग नको.')
q('child_medium','medium','child',
'Your friend wants to touch a cub. Your guide says stay away. Whom should you follow?|The guide; ask your friend to stay back.|Your friend for fun.|The person with a camera.|Whoever speaks first.|A friend’s excitement does not make a cub safe to approach.',
'दोस्त बाघ के बच्चे को छूना चाहता है। गाइड दूर रहने को कहता है। किसकी सुनें?|गाइड की; दोस्त को भी दूर रखें।|मज़े के लिए दोस्त की।|कैमरे वाले की।|जो पहले बोले उसकी।|दोस्त का उत्साह बच्चे के पास जाना सुरक्षित नहीं बनाता।',
'मित्राला वाघाच्या पिल्लाला हात लावायचा आहे. मार्गदर्शक दूर राहायला सांगतो. कोणाचे ऐकाल?|मार्गदर्शकाचे; मित्रालाही मागे राहायला सांगा.|मजेसाठी मित्राचे.|कॅमेरा असलेल्याचे.|आधी बोलेल त्याचे.|मित्राचा उत्साह पिल्लाजवळ जाणे सुरक्षित करत नाही.')
q('child_high','high','child',
'An online video says feeding animals is kind. Your guide says it harms them. Which reason is stronger?|Feeding can change wild behaviour.|The video has more likes.|The food looks tasty.|The animal looks cute.|Judge the reason, not the popularity of a video.',
'वीडियो कहता है जानवरों को खिलाना दया है। गाइड कहता है हानि होती है। मजबूत कारण कौन सा?|खिलाने से जंगली व्यवहार बदल सकता है।|वीडियो के अधिक लाइक हैं।|खाना स्वादिष्ट दिखता है।|जानवर प्यारा है।|वीडियो की लोकप्रियता नहीं, कारण को परखें।',
'व्हिडिओ म्हणतो खाऊ घालणे दया आहे. मार्गदर्शक म्हणतो नुकसान होते. ठोस कारण कोणते?|खाऊ घातल्याने जंगली वर्तन बदलू शकते.|व्हिडिओला जास्त लाइक आहेत.|अन्न चविष्ट दिसते.|प्राणी गोंडस आहे.|व्हिडिओची लोकप्रियता नव्हे, कारण तपासा.')
q('young_low','low','young',
'A friend proposes a tiger selfie outside the safari vehicle. Your response?|Decline and stay inside.|Accept the dare.|Hold the door for them.|Go first.|Do not leave the vehicle for a wildlife selfie.',
'दोस्त सफारी वाहन से बाहर बाघ संग सेल्फी चाहता है। आपका जवाब?|मना करें और अंदर रहें।|चुनौती स्वीकारें।|उसके लिए दरवाज़ा पकड़ें।|पहले खुद जाएँ।|वन्यजीव सेल्फी के लिए वाहन से बाहर न निकलें।',
'मित्राला सफारी वाहनाबाहेर वाघासोबत सेल्फी हवी आहे. तुमचे उत्तर?|नकार द्या आणि आत राहा.|आव्हान स्वीकारा.|त्याच्यासाठी दार धरा.|आधी स्वतः जा.|वन्यजीव सेल्फीसाठी वाहनाबाहेर उतरू नका.')
q('young_medium','medium','young',
'Your group dares you to cross a closed trail barrier. What do you do?|Refuse and suggest the open route.|Cross to prove courage.|Film a friend crossing.|Cross when staff leave.|A safe choice can mean resisting peer pressure.',
'समूह आपको बंद राह की रोक पार करने की चुनौती देता है। क्या करें?|मना करें और खुली राह सुझाएँ।|हिम्मत साबित करने को पार करें।|दोस्त को पार करते फिल्माएँ।|कर्मचारी जाएँ तब पार करें।|सुरक्षित निर्णय के लिए साथियों के दबाव का विरोध करना पड़ सकता है।',
'गट बंद वाटेचा अडथळा ओलांडण्याचे आव्हान देतो. काय कराल?|नकार द्या आणि खुली वाट सुचवा.|धाडस दाखवायला ओलांडा.|मित्र ओलांडताना चित्रण करा.|कर्मचारी गेल्यावर ओलांडा.|सुरक्षित निर्णयासाठी मित्रांच्या दबावाला विरोध करावा लागू शकतो.')
q('young_high','high','young',
'A viral post promises a safe secret tiger trail. No official source confirms it. What is rational?|Check authorised guidance; do not enter on that claim.|Trust the high view count.|Go because friends shared it.|Assume secret means safer.|Popularity is not verification of safety or permission.',
'वायरल पोस्ट सुरक्षित गुप्त बाघ राह का दावा करती है। अधिकृत पुष्टि नहीं। समझदारी क्या है?|अधिकृत सलाह जाँचें; दावे पर प्रवेश न करें।|अधिक व्यूज़ पर भरोसा करें।|दोस्तों ने भेजा तो जाएँ।|गुप्त है तो सुरक्षित मानें।|लोकप्रियता सुरक्षा या अनुमति का प्रमाण नहीं है।',
'व्हायरल पोस्ट सुरक्षित गुप्त व्याघ्रवाट सांगते. अधिकृत खात्री नाही. योग्य विचार?|अधिकृत मार्गदर्शन तपासा; दाव्यावरून जाऊ नका.|जास्त व्ह्यूवर विश्वास ठेवा.|मित्रांनी पाठवले म्हणून जा.|गुप्त म्हणजे सुरक्षित समजा.|लोकप्रियता म्हणजे सुरक्षा किंवा परवानगीचा पुरावा नाही.')
q('adult_low','low','adult',
'You are arranging a forest visit for your family. What comes first?|Check permits, routes and authorised guides.|Plan an unapproved shortcut.|Promise a close tiger photo.|Ignore entry rules.|Plan within current access rules rather than around a promised sighting.',
'परिवार की वन यात्रा की योजना है। पहले क्या करें?|अनुमति, राह और अधिकृत गाइड जाँचें।|अनुमति बिना छोटी राह चुनें।|पास से बाघ के फोटो का वादा करें।|प्रवेश नियम अनदेखे करें।|निश्चित दर्शन के बजाय वर्तमान प्रवेश नियमों के अनुसार योजना बनाएँ।',
'कुटुंबाची वनभेट ठरवत आहात. आधी काय कराल?|परवानग्या, वाटा आणि अधिकृत मार्गदर्शक तपासा.|अनधिकृत जवळची वाट ठरवा.|जवळून वाघाचा फोटो देण्याचे वचन द्या.|प्रवेश नियम दुर्लक्षित करा.|दर्शनाच्या वचनाऐवजी सध्याच्या प्रवेश नियमांनुसार योजना करा.')
q('adult_medium','medium','adult',
'Your schedule is late. A closed shortcut would save time. What should you prioritise?|Adjust the schedule and respect the closure.|Use the shortcut just once.|Ask the family to hurry through.|Ignore the barrier if it looks empty.|Schedule pressure does not justify entering a closed area.',
'समय कम है। बंद छोटी राह समय बचाएगी। प्राथमिकता क्या हो?|समय-योजना बदलें; बंद राह का सम्मान करें।|बस एक बार छोटी राह लें।|परिवार को जल्दी पार कराएँ।|खाली दिखे तो रोक अनदेखी करें।|समय का दबाव बंद क्षेत्र में प्रवेश का कारण नहीं बनता।',
'वेळ कमी आहे. बंद जवळची वाट वेळ वाचवेल. प्राधान्य कशाला?|वेळापत्रक बदला; बंदी पाळा.|एकदाच जवळची वाट घ्या.|कुटुंबाला घाईने नेऊन या.|रिकामे दिसले तर अडथळा दुर्लक्षित करा.|वेळेचा ताण बंद भागात प्रवेशाचे समर्थन करत नाही.')
q('adult_high','high','adult',
'Two plans fit your budget: an authorised guided visit or an unverified close-encounter offer. Which evidence matters?|Verified permission and qualified local guidance.|Only the lower price.|A promise of guaranteed proximity.|A dramatic advertisement.|Evaluate legitimacy and risk before price or spectacle.',
'दो योजनाएँ बजट में हैं: अधिकृत गाइड वाली यात्रा या अपुष्ट नज़दीकी सामना। क्या अहम है?|सत्यापित अनुमति और योग्य स्थानीय मार्गदर्शन।|केवल कम कीमत।|ज़रूर पास जाने का वादा।|नाटकीय विज्ञापन।|कीमत या रोमांच से पहले वैधता और जोखिम परखें।',
'दोन योजना बजेटमध्ये: अधिकृत मार्गदर्शित भेट किंवा अप्रमाणित जवळची भेट. काय महत्त्वाचे?|पडताळलेली परवानगी आणि पात्र स्थानिक मार्गदर्शन.|फक्त कमी किंमत.|जवळ जाण्याची हमी.|नाट्यमय जाहिरात.|किंमत किंवा थराराआधी वैधता आणि धोका तपासा.')
q('older_low','low','older',
'You return to a reserve after many years. What should you check?|Today’s rules and authorised routes.|Only what you remember.|The route from an old photo.|A decades-old timetable.|Local access rules can change; check current information.',
'कई वर्षों बाद अभयारण्य लौटे हैं। क्या जाँचें?|आज के नियम और अधिकृत राहें।|केवल अपनी याद।|पुराने फोटो का रास्ता।|दशकों पुरानी समय-सारणी।|स्थानीय प्रवेश नियम बदल सकते हैं; वर्तमान जानकारी लें।',
'अनेक वर्षांनी अभयारण्यात परत आलात. काय तपासाल?|आजचे नियम आणि अधिकृत वाटा.|फक्त तुमच्या आठवणी.|जुन्या फोटोतील वाट.|अनेक वर्षांपूर्वीचे वेळापत्रक.|स्थानिक प्रवेश नियम बदलू शकतात; सध्याची माहिती घ्या.')
q('older_medium','medium','older',
'You want a different pace from your group. What is a sensible plan?|Discuss permitted options with the guide.|Leave the group unannounced.|Take a closed path alone.|Ask others to ignore the rules.|Communicate preferences and plan within authorised options.',
'आप समूह से अलग गति चाहते हैं। समझदार योजना क्या है?|गाइड से अनुमत विकल्पों पर बात करें।|बिना बताए समूह छोड़ें।|अकेले बंद राह लें।|सबको नियम तोड़ने को कहें।|अपनी पसंद बताएँ और अनुमत विकल्पों में योजना बनाएँ।',
'तुम्हाला गटापेक्षा वेगळी गती हवी आहे. समंजस योजना?|मार्गदर्शकाशी अनुमत पर्यायांवर चर्चा करा.|न सांगता गट सोडा.|एकटे बंद वाट घ्या.|इतरांना नियम मोडायला सांगा.|तुमची पसंती सांगा आणि अधिकृत पर्यायांत योजना करा.')
q('older_high','high','older',
'Past experience says a trail was safe. New ranger information says wildlife activity has changed. What should lead your decision?|Combine experience with current official advice.|Treat memory as a guarantee.|Dismiss the new warning.|Assume familiar means risk-free.|Experience is valuable, but conditions and evidence can change.',
'अनुभव कहता है राह सुरक्षित थी। नई वनरक्षक सूचना कहती है गतिविधि बदली है। निर्णय कैसे लें?|अनुभव संग वर्तमान अधिकृत सलाह लें।|याद को गारंटी मानें।|नई चेतावनी छोड़ दें।|परिचित को जोखिम-मुक्त मानें।|अनुभव उपयोगी है, पर स्थिति और प्रमाण बदल सकते हैं।',
'अनुभवानुसार वाट सुरक्षित होती. वनरक्षकाची नवी माहिती बदललेली हालचाल सांगते. निर्णय कसा घ्याल?|अनुभवासोबत सध्याचा अधिकृत सल्ला वापरा.|आठवणीला हमी समजा.|नवा इशारा नाकारा.|ओळखीचे म्हणजे धोकामुक्त समजा.|अनुभव मोलाचा आहे, पण परिस्थिती आणि पुरावे बदलू शकतात.')

if __name__=='__main__':
    import json
    from pathlib import Path
    def lit(s):return json.dumps(s,ensure_ascii=False)
    def l3(a):return 'LocalText('+','.join(lit(s) for s in a)+')'
    header='''import 'strings.dart';
class ForestQuestion {
 final String id, difficulty, audience;
 final LocalText prompt, explanation;
 final List<LocalText> options;
 final int correctIndex;
 const ForestQuestion(this.id,this.difficulty,this.audience,this.prompt,this.options,this.explanation,{this.correctIndex=0});
}
const questions=<ForestQuestion>[\n'''
    for d in DATA:
        rows=d['rows'];header+=' ForestQuestion('+','.join(lit(d[k]) for k in ['id','level','audience'])+','+l3([r[0] for r in rows])+',['+','.join(l3([r[i] for r in rows]) for i in range(1,5))+'],'+l3([r[5] for r in rows])+'),\n'
    Path(__file__).resolve().parents[1].joinpath('lib/game/questions.dart').write_text(header+'];\n')
    print('Generated',len(DATA),'questions in three languages')
