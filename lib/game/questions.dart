import 'strings.dart';

class ForestQuestion {
  final String id, difficulty, audience;
  final LocalText prompt, explanation;
  final List<LocalText> options;
  final int correctIndex;
  const ForestQuestion(
    this.id,
    this.difficulty,
    this.audience,
    this.prompt,
    this.options,
    this.explanation, {
    this.correctIndex = 0,
  });
}

const questions = <ForestQuestion>[
  ForestQuestion(
    "space",
    "low",
    "all",
    LocalText(
      "A distant tiger is crossing the path. What should you do?",
      "दूर एक बाघ रास्ता पार कर रहा है। क्या करें?",
      "दूर एक वाघ वाट ओलांडत आहे. काय कराल?",
    ),
    [
      LocalText(
        "Give it space; do not follow.",
        "उसे जगह दें; पीछा न करें।",
        "त्याला जागा द्या; पाठलाग नको.",
      ),
      LocalText("Run after it.", "उसके पीछे दौड़ें।", "त्याच्यामागे धावा."),
      LocalText("Block the path.", "रास्ता रोकें।", "वाट अडवा."),
      LocalText("Call it closer.", "उसे पास बुलाएँ।", "त्याला जवळ बोलवा."),
    ],
    LocalText(
      "Let wildlife pass without following or blocking it.",
      "वन्यजीव को बिना पीछा किए या रोके निकलने दें।",
      "वन्यजीवाला न अडवता किंवा पाठलाग न करता जाऊ द्या.",
    ),
  ),
  ForestQuestion(
    "cubs",
    "low",
    "all",
    LocalText(
      "You notice tiger cubs. No adult is visible. What now?",
      "बाघ के बच्चे दिखे, बड़ा बाघ नहीं दिखा। अब क्या?",
      "वाघाची पिल्ले दिसली; मोठा वाघ दिसत नाही. काय कराल?",
    ),
    [
      LocalText(
        "Keep away and tell your guide.",
        "दूर रहें और गाइड को बताएँ।",
        "दूर राहा आणि मार्गदर्शकाला सांगा.",
      ),
      LocalText("Touch a cub.", "बच्चे को छुएँ।", "पिल्लाला स्पर्श करा."),
      LocalText("Offer food.", "खाना दें।", "खायला द्या."),
      LocalText("Wait beside them.", "उनके पास रुकें।", "त्यांच्याजवळ थांबा."),
    ],
    LocalText(
      "An adult may be nearby. Never approach or handle cubs.",
      "बड़ा बाघ पास हो सकता है। बच्चों के पास न जाएँ, न छुएँ।",
      "मोठा वाघ जवळ असू शकतो. पिल्लांजवळ जाऊ नका, हाताळू नका.",
    ),
  ),
  ForestQuestion(
    "food",
    "low",
    "all",
    LocalText(
      "A visitor offers food to attract wildlife. Your choice?",
      "कोई वन्यजीव को बुलाने के लिए खाना देता है। आपकी पसंद?",
      "कोणी वन्यजीवाला बोलवण्यासाठी अन्न देत आहे. तुमची निवड?",
    ),
    [
      LocalText(
        "Do not feed or lure animals.",
        "जानवर को खाना देकर न बुलाएँ।",
        "अन्न देऊन प्राण्याला बोलावू नका.",
      ),
      LocalText("Add more food.", "और खाना दें।", "आणखी अन्न द्या."),
      LocalText("Feed by hand.", "हाथ से खिलाएँ।", "हाताने भरवा."),
      LocalText(
        "Hide food on the trail.",
        "राह पर खाना छिपाएँ।",
        "वाटेवर अन्न लपवा.",
      ),
    ],
    LocalText(
      "Feeding can change behaviour and create conflict.",
      "खिलाने से व्यवहार बदल सकता है और टकराव बढ़ सकता है।",
      "खाऊ घातल्याने वर्तन बदलू शकते आणि संघर्ष वाढू शकतो.",
    ),
  ),
  ForestQuestion(
    "vehicle",
    "low",
    "all",
    LocalText(
      "A tiger rests near your safari vehicle. What is appropriate?",
      "सफारी वाहन के पास बाघ आराम कर रहा है। क्या सही है?",
      "सफारी वाहनाजवळ वाघ विश्रांती घेत आहे. काय योग्य आहे?",
    ),
    [
      LocalText(
        "Stay inside; listen to the guide.",
        "अंदर रहें; गाइड की सुनें।",
        "आत राहा; मार्गदर्शकाचे ऐका.",
      ),
      LocalText(
        "Step out for a photo.",
        "फोटो के लिए उतरें।",
        "फोटोसाठी उतरा.",
      ),
      LocalText(
        "Reach towards it.",
        "उसकी ओर हाथ बढ़ाएँ।",
        "त्याच्याकडे हात न्या.",
      ),
      LocalText("Climb onto the roof.", "छत पर चढ़ें।", "छतावर चढा."),
    ],
    LocalText(
      "Remain in the vehicle unless authorised staff permit exit.",
      "अधिकृत कर्मचारी अनुमति न दें तो वाहन में ही रहें।",
      "अधिकृत कर्मचारी परवानगी देत नाहीत तोवर वाहनातच राहा.",
    ),
  ),
  ForestQuestion(
    "litter",
    "low",
    "all",
    LocalText(
      "You have an empty snack wrapper. Where should it go?",
      "नाश्ते का खाली पैकेट है। कहाँ रखें?",
      "खाऊचे रिकामे पाकीट आहे. कुठे टाकाल?",
    ),
    [
      LocalText(
        "Carry it to an authorised bin.",
        "निर्धारित कूड़ेदान तक ले जाएँ।",
        "ठरवलेल्या कचरापेटीपर्यंत न्या.",
      ),
      LocalText("Under a stone.", "पत्थर के नीचे।", "दगडाखाली."),
      LocalText("Into the stream.", "धारा में।", "ओढ्यात."),
      LocalText("Behind a tree.", "पेड़ के पीछे।", "झाडामागे."),
    ],
    LocalText(
      "Carry waste back or use designated facilities.",
      "कचरा वापस ले जाएँ या निर्धारित सुविधा का उपयोग करें।",
      "कचरा परत न्या किंवा ठरवलेली सुविधा वापरा.",
    ),
  ),
  ForestQuestion(
    "closed",
    "low",
    "all",
    LocalText(
      "A ranger has closed a trail. What should you do?",
      "वनरक्षक ने रास्ता बंद किया है। क्या करें?",
      "वनरक्षकाने वाट बंद केली आहे. काय कराल?",
    ),
    [
      LocalText(
        "Use an authorised alternative.",
        "अनुमत दूसरा रास्ता लें।",
        "अधिकृत दुसरी वाट घ्या.",
      ),
      LocalText("Cross the barrier.", "रोक पार करें।", "अडथळा ओलांडा."),
      LocalText(
        "Follow footprints past it.",
        "पैरों के निशान के पीछे जाएँ।",
        "पावलांच्या खुणांमागे जा.",
      ),
      LocalText(
        "Go when nobody looks.",
        "चुपके से निकलें।",
        "कोणी पाहत नसताना जा.",
      ),
    ],
    LocalText(
      "Current local restrictions must be respected.",
      "वर्तमान स्थानीय प्रतिबंधों का पालन करें।",
      "सध्याचे स्थानिक निर्बंध पाळा.",
    ),
  ),
  ForestQuestion(
    "quiet",
    "low",
    "all",
    LocalText(
      "From a vehicle, you watch an undisturbed tiger. What is respectful?",
      "वाहन से शांत बाघ देख रहे हैं। सम्मानजनक व्यवहार क्या है?",
      "वाहनातून शांत वाघ पाहत आहात. आदराने कसे वागाल?",
    ),
    [
      LocalText(
        "Watch quietly with the guide.",
        "गाइड के साथ चुपचाप देखें।",
        "मार्गदर्शकासोबत शांतपणे पाहा.",
      ),
      LocalText(
        "Shout for attention.",
        "ध्यान खींचने को चिल्लाएँ।",
        "लक्ष वेधण्यासाठी ओरडा.",
      ),
      LocalText(
        "Play animal calls.",
        "जानवरों की आवाज़ चलाएँ।",
        "प्राण्यांचे आवाज वाजवा.",
      ),
      LocalText("Bang on the vehicle.", "वाहन पर चोट करें।", "वाहनावर आपटा."),
    ],
    LocalText(
      "Do not disturb a calm safari sighting. Emergency situations differ.",
      "शांत सफारी दृश्य में बाधा न डालें। आपात स्थिति अलग होती है।",
      "शांत सफारी दर्शनात व्यत्यय आणू नका. आपत्कालीन प्रसंग वेगळे असतात.",
    ),
  ),
  ForestQuestion(
    "resting",
    "low",
    "all",
    LocalText(
      "A wild tiger looks calm. What does that mean?",
      "जंगली बाघ शांत दिखता है। इसका क्या अर्थ है?",
      "जंगली वाघ शांत दिसतो. याचा अर्थ काय?",
    ),
    [
      LocalText(
        "It still needs distance.",
        "फिर भी दूरी ज़रूरी है।",
        "तरीही अंतर ठेवणे गरजेचे आहे.",
      ),
      LocalText(
        "It is safe to touch.",
        "उसे छूना सुरक्षित है।",
        "स्पर्श करणे सुरक्षित आहे.",
      ),
      LocalText("It is tame.", "वह पालतू है।", "तो पाळीव आहे."),
      LocalText(
        "It cannot react quickly.",
        "वह जल्दी प्रतिक्रिया नहीं देगा।",
        "तो पटकन प्रतिक्रिया देणार नाही.",
      ),
    ],
    LocalText(
      "A calm appearance is not permission to approach.",
      "शांत दिखना पास जाने की अनुमति नहीं है।",
      "शांत दिसणे म्हणजे जवळ जाण्याची परवानगी नाही.",
    ),
  ),
  ForestQuestion(
    "photo",
    "medium",
    "all",
    LocalText(
      "Your phone cannot capture a distant tiger clearly. Which priority matters more?",
      "दूर के बाघ का फोटो साफ नहीं आता। क्या अधिक ज़रूरी है?",
      "दूरच्या वाघाचा फोटो स्पष्ट येत नाही. काय जास्त महत्त्वाचे?",
    ),
    [
      LocalText(
        "Keep distance; accept a smaller photo.",
        "दूरी रखें; छोटा फोटो स्वीकारें।",
        "अंतर ठेवा; छोटा फोटो स्वीकारा.",
      ),
      LocalText(
        "Move closer for detail.",
        "विवरण के लिए पास जाएँ।",
        "तपशीलासाठी जवळ जा.",
      ),
      LocalText(
        "Ask the driver to chase it.",
        "चालक से पीछा करवाएँ।",
        "चालकाला पाठलाग करायला सांगा.",
      ),
      LocalText(
        "Step off the route quietly.",
        "चुपचाप रास्ता छोड़ें।",
        "हळूच वाट सोडा.",
      ),
    ],
    LocalText(
      "Respecting wildlife matters more than getting a photograph.",
      "फोटो से अधिक महत्वपूर्ण वन्यजीव का सम्मान है।",
      "फोटोपेक्षा वन्यजीवाचा आदर महत्त्वाचा आहे.",
    ),
  ),
  ForestQuestion(
    "tracks",
    "medium",
    "all",
    LocalText(
      "Fresh tracks leave your approved route. Your friend wants to follow. What do you choose?",
      "ताज़े निशान अनुमत राह से बाहर जाते हैं। दोस्त पीछा करना चाहता है। क्या चुनें?",
      "ताज्या खुणा अधिकृत वाटेबाहेर जातात. मित्र पाठलाग करू इच्छितो. काय निवडाल?",
    ),
    [
      LocalText(
        "Tell the guide and stay on the route.",
        "गाइड को बताएँ; राह पर रहें।",
        "मार्गदर्शकाला सांगा; वाटेवर राहा.",
      ),
      LocalText("Follow together.", "साथ में पीछा करें।", "एकत्र पाठलाग करा."),
      LocalText(
        "Follow alone to reduce noise.",
        "कम शोर के लिए अकेले जाएँ।",
        "आवाज कमी होईल म्हणून एकटे जा.",
      ),
      LocalText(
        "Search the bushes nearby.",
        "पास की झाड़ियाँ खोजें।",
        "जवळची झुडपे शोधा.",
      ),
    ],
    LocalText(
      "Tracks are information for the guide, not permission to track a tiger.",
      "निशान गाइड के लिए सूचना हैं, बाघ का पीछा करने की अनुमति नहीं।",
      "खुणा म्हणजे मार्गदर्शकासाठी माहिती, वाघाचा माग काढण्याची परवानगी नाही.",
    ),
  ),
  ForestQuestion(
    "injured",
    "medium",
    "all",
    LocalText(
      "A tiger appears injured. You want to help. What is the appropriate first step?",
      "बाघ घायल लगता है। आप मदद करना चाहते हैं। पहला सही कदम?",
      "वाघ जखमी वाटतो. तुम्हाला मदत करायची आहे. पहिले योग्य पाऊल?",
    ),
    [
      LocalText(
        "Keep away and alert wildlife staff.",
        "दूर रहकर वन कर्मचारियों को बताएँ।",
        "दूर राहून वन कर्मचाऱ्यांना सांगा.",
      ),
      LocalText(
        "Offer water by hand.",
        "हाथ से पानी दें।",
        "हाताने पाणी द्या.",
      ),
      LocalText(
        "Try to touch its leg.",
        "उसका पैर छुएँ।",
        "त्याच्या पायाला हात लावा.",
      ),
      LocalText(
        "Gather a crowd around it.",
        "उसके आसपास भीड़ बुलाएँ।",
        "त्याच्याभोवती गर्दी जमवा.",
      ),
    ],
    LocalText(
      "Compassion means getting trained help without approaching.",
      "करुणा का अर्थ पास गए बिना प्रशिक्षित मदद बुलाना है।",
      "जवळ न जाता प्रशिक्षित मदत मिळवणे हीच योग्य मदत आहे.",
    ),
  ),
  ForestQuestion(
    "group",
    "medium",
    "all",
    LocalText(
      "A tiger is nearby. Someone suggests scattering to distract it. What is better?",
      "बाघ पास है। कोई ध्यान भटकाने के लिए बिखरने को कहता है। बेहतर क्या है?",
      "वाघ जवळ आहे. लक्ष विचलित करण्यासाठी पांगावे असे कोणी म्हणते. योग्य काय?",
    ),
    [
      LocalText(
        "Stay together and follow the guide.",
        "साथ रहें और गाइड की सुनें।",
        "एकत्र राहा; मार्गदर्शकाचे ऐका.",
      ),
      LocalText(
        "Run in different directions.",
        "अलग दिशाओं में दौड़ें।",
        "वेगवेगळ्या दिशांना धावा.",
      ),
      LocalText(
        "Send one person closer.",
        "एक व्यक्ति पास भेजें।",
        "एकाला जवळ पाठवा.",
      ),
      LocalText(
        "Leave someone behind.",
        "किसी को पीछे छोड़ें।",
        "कोणाला मागे सोडा.",
      ),
    ],
    LocalText(
      "Do not scatter or run. Follow trained local directions.",
      "बिखरें या दौड़ें नहीं। प्रशिक्षित स्थानीय निर्देश मानें।",
      "पांगू नका किंवा धावू नका. प्रशिक्षित स्थानिक निर्देश पाळा.",
    ),
  ),
  ForestQuestion(
    "report",
    "medium",
    "all",
    LocalText(
      "You are safely away after a sighting. Which report is most useful?",
      "दर्शन के बाद आप सुरक्षित दूर हैं। कौन सी सूचना सबसे उपयोगी है?",
      "दर्शनानंतर तुम्ही सुरक्षित दूर आहात. कोणती माहिती उपयुक्त?",
    ),
    [
      LocalText(
        "Time, place, behaviour and direction.",
        "समय, स्थान, व्यवहार और दिशा।",
        "वेळ, ठिकाण, वर्तन आणि दिशा.",
      ),
      LocalText(
        "A dramatic guess about its mood.",
        "उसके मूड का नाटकीय अनुमान।",
        "त्याच्या मनःस्थितीचा अंदाज.",
      ),
      LocalText(
        "Only a blurry photo.",
        "केवल धुंधला फोटो।",
        "फक्त अस्पष्ट फोटो.",
      ),
      LocalText(
        "A claim that all tigers are tame.",
        "सभी बाघ पालतू हैं, यह दावा।",
        "सगळे वाघ पाळीव असल्याचा दावा.",
      ),
    ],
    LocalText(
      "Report observed facts rather than guessing intentions.",
      "इरादे का अनुमान लगाने के बजाय देखे हुए तथ्य बताएँ।",
      "हेतूचा अंदाज न लावता पाहिलेली तथ्ये सांगा.",
    ),
  ),
  ForestQuestion(
    "carcass",
    "medium",
    "all",
    LocalText(
      "A fresh carcass lies beside a shortcut. Which route should you prefer?",
      "छोटे रास्ते के पास ताज़ा शव है। कौन सी राह चुनें?",
      "जवळच्या वाटेवर ताजे मृत जनावर आहे. कोणती वाट निवडाल?",
    ),
    [
      LocalText(
        "Avoid it and consult the guide.",
        "उससे बचें और गाइड से पूछें।",
        "ते टाळा आणि मार्गदर्शकाला विचारा.",
      ),
      LocalText(
        "Pass close to inspect it.",
        "जाँचने के लिए पास जाएँ।",
        "तपासण्यासाठी जवळ जा.",
      ),
      LocalText(
        "Wait beside it for wildlife.",
        "वन्यजीव के लिए वहीं रुकें।",
        "वन्यजीवासाठी तिथे थांबा.",
      ),
      LocalText(
        "Move it off the path.",
        "उसे रास्ते से हटाएँ।",
        "ते वाटेवरून हलवा.",
      ),
    ],
    LocalText(
      "A predator may be nearby or return. Do not approach a kill.",
      "शिकारी पास हो सकता है या लौट सकता है। शिकार के पास न जाएँ।",
      "शिकारी जवळ असू शकतो किंवा परत येऊ शकतो. शिकारीजवळ जाऊ नका.",
    ),
  ),
  ForestQuestion(
    "notseen",
    "medium",
    "all",
    LocalText(
      "Your visit is ending without a tiger sighting. What is responsible?",
      "यात्रा समाप्त हो रही है, बाघ नहीं दिखा। जिम्मेदार निर्णय?",
      "भेट संपत आली; वाघ दिसला नाही. जबाबदार निर्णय?",
    ),
    [
      LocalText(
        "Leave on time; sightings are not guaranteed.",
        "समय पर लौटें; दर्शन तय नहीं हैं।",
        "वेळेत परता; दर्शनाची हमी नसते.",
      ),
      LocalText(
        "Ask the guide to bait a tiger.",
        "गाइड से चारा रखने को कहें।",
        "मार्गदर्शकाला आमिष ठेवायला सांगा.",
      ),
      LocalText(
        "Stay after closing.",
        "बंद होने के बाद रुकें।",
        "वेळ संपल्यावरही थांबा.",
      ),
      LocalText(
        "Search alone on foot.",
        "अकेले पैदल खोजें।",
        "एकटे पायी शोधा.",
      ),
    ],
    LocalText(
      "Respect access times rather than chasing a guaranteed sighting.",
      "निश्चित दर्शन के लिए पीछा करने के बजाय समय का पालन करें।",
      "दर्शनासाठी पाठलाग न करता प्रवेशाच्या वेळा पाळा.",
    ),
  ),
  ForestQuestion(
    "blocked",
    "medium",
    "all",
    LocalText(
      "Vehicles are crowding around a tiger. What should you support?",
      "वाहन बाघ के आसपास जमा हैं। किस बात का समर्थन करें?",
      "वाघाभोवती वाहने जमा झाली आहेत. कशाला पाठिंबा द्याल?",
    ),
    [
      LocalText(
        "Guide-managed spacing and an open exit.",
        "गाइड के अनुसार दूरी और खुला रास्ता।",
        "मार्गदर्शकानुसार अंतर आणि खुली वाट.",
      ),
      LocalText(
        "A tighter circle for photos.",
        "फोटो के लिए घेरा छोटा करें।",
        "फोटोसाठी आणखी घट्ट घेरा.",
      ),
      LocalText(
        "Blocking both ends of the road.",
        "सड़क के दोनों सिरे रोकें।",
        "रस्त्याची दोन्ही टोके अडवा.",
      ),
      LocalText(
        "Getting out to direct it.",
        "उतरकर उसे दिशा दें।",
        "उतरून त्याला दिशा द्या.",
      ),
    ],
    LocalText(
      "Wildlife needs an unobstructed way out, not an audience barrier.",
      "वन्यजीव को निकलने का खुला रास्ता चाहिए, दर्शकों की दीवार नहीं।",
      "वन्यजीवाला बाहेर पडण्याची मोकळी वाट हवी, प्रेक्षकांची भिंत नव्हे.",
    ),
  ),
  ForestQuestion(
    "evidence",
    "high",
    "all",
    LocalText(
      "An old map says open; a ranger says closed after a sighting. Which evidence should guide your choice?",
      "पुराने नक्शे में राह खुली है; दर्शन के बाद वनरक्षक ने बंद कहा। किस सूचना पर निर्णय लें?",
      "जुन्या नकाशात वाट खुली; दर्शनानंतर वनरक्षक बंद म्हणतो. कोणती माहिती वापराल?",
    ),
    [
      LocalText(
        "Current ranger instructions.",
        "वनरक्षक के वर्तमान निर्देश।",
        "वनरक्षकाचे सध्याचे निर्देश.",
      ),
      LocalText(
        "The map because it is printed.",
        "छपा होने से पुराना नक्शा।",
        "छापील असल्याने जुना नकाशा.",
      ),
      LocalText(
        "The shortest distance alone.",
        "केवल सबसे छोटी दूरी।",
        "फक्त सर्वात कमी अंतर.",
      ),
      LocalText(
        "A stranger who has not checked.",
        "बिना जाँच वाले अजनबी की बात।",
        "तपासणी न केलेल्या अनोळखीचे मत.",
      ),
    ],
    LocalText(
      "Current authorised information outweighs outdated route information.",
      "वर्तमान अधिकृत जानकारी पुरानी मार्ग सूचना से अधिक महत्वपूर्ण है।",
      "सध्याची अधिकृत माहिती जुन्या मार्गमाहितीपेक्षा महत्त्वाची आहे.",
    ),
  ),
  ForestQuestion(
    "uncertain",
    "high",
    "all",
    LocalText(
      "A tiger vanishes into cover. You cannot tell where it went. What does uncertainty imply?",
      "बाघ झाड़ियों में ओझल है। दिशा पता नहीं। इस अनिश्चितता का क्या अर्थ है?",
      "वाघ झुडपात दिसेनासा झाला. दिशा माहीत नाही. अनिश्चिततेचा अर्थ काय?",
    ),
    [
      LocalText(
        "Do not follow; consult the guide.",
        "पीछा न करें; गाइड से पूछें।",
        "पाठलाग नको; मार्गदर्शकाला विचारा.",
      ),
      LocalText(
        "The area must now be safe.",
        "जगह अब ज़रूर सुरक्षित है।",
        "जागा आता नक्की सुरक्षित आहे.",
      ),
      LocalText(
        "It wants you to follow.",
        "वह चाहता है आप पीछे आएँ।",
        "त्याला तुम्ही मागे यावे वाटते.",
      ),
      LocalText(
        "You should search every bush.",
        "हर झाड़ी में खोजें।",
        "प्रत्येक झुडपात शोधा.",
      ),
    ],
    LocalText(
      "Not seeing an animal is not evidence that approaching is safe.",
      "जानवर न दिखना, पास जाना सुरक्षित होने का प्रमाण नहीं है।",
      "प्राणी दिसत नाही म्हणजे जवळ जाणे सुरक्षित आहे असा पुरावा नाही.",
    ),
  ),
  ForestQuestion(
    "tradeoff",
    "high",
    "all",
    LocalText(
      "A shortcut saves time but leaves the permitted route. The longer route is authorised. Which matters most?",
      "छोटी राह समय बचाती है पर अनुमत मार्ग से बाहर है। लंबी राह अधिकृत है। क्या सबसे ज़रूरी?",
      "जवळची वाट वेळ वाचवते पण परवानगीबाहेर आहे. लांब वाट अधिकृत आहे. महत्त्वाचे काय?",
    ),
    [
      LocalText(
        "Permission and safety, not saved time.",
        "अनुमति और सुरक्षा, केवल समय नहीं।",
        "परवानगी आणि सुरक्षा, फक्त वेळ नव्हे.",
      ),
      LocalText(
        "Time saved above all else.",
        "हर चीज़ से अधिक समय बचाना।",
        "कशाहीपेक्षा वेळ वाचवणे.",
      ),
      LocalText(
        "Whether friends will follow.",
        "दोस्त साथ आएँगे या नहीं।",
        "मित्र येतील की नाही.",
      ),
      LocalText(
        "Whether anyone can see you.",
        "कोई देख रहा है या नहीं।",
        "कोणी पाहत आहे की नाही.",
      ),
    ],
    LocalText(
      "Do not trade away access rules for convenience.",
      "सुविधा के लिए प्रवेश नियमों से समझौता न करें।",
      "सोयीसाठी प्रवेशाच्या नियमांशी तडजोड करू नका.",
    ),
  ),
  ForestQuestion(
    "sequence",
    "high",
    "all",
    LocalText(
      "You notice a wildlife hazard while still nearby. Which sequence makes sense?",
      "पास रहते हुए वन्यजीव का खतरा दिखा। उचित क्रम क्या है?",
      "जवळ असताना वन्यजीवाचा धोका दिसला. योग्य क्रम कोणता?",
    ),
    [
      LocalText(
        "Reach safety with the guide, then report facts.",
        "गाइड संग सुरक्षित जाएँ, फिर तथ्य बताएँ।",
        "मार्गदर्शकासोबत सुरक्षित जा, मग तथ्ये सांगा.",
      ),
      LocalText(
        "Stop beside it to post online.",
        "पास रुककर ऑनलाइन पोस्ट करें।",
        "जवळ थांबून ऑनलाइन पोस्ट करा.",
      ),
      LocalText(
        "Approach first, then ask advice.",
        "पहले पास जाएँ, फिर सलाह लें।",
        "आधी जवळ जा, मग सल्ला घ्या.",
      ),
      LocalText(
        "Gather spectators, then leave.",
        "दर्शक बुलाएँ, फिर जाएँ।",
        "प्रेक्षक जमवा, मग जा.",
      ),
    ],
    LocalText(
      "Do not delay safe distancing to document or publicise a hazard.",
      "खतरे का प्रचार या रिकॉर्ड करने के लिए सुरक्षित दूरी बनाने में देर न करें।",
      "धोका नोंदवण्यासाठी किंवा प्रसिद्धीसाठी सुरक्षित अंतर ठेवण्यास उशीर करू नका.",
    ),
  ),
  ForestQuestion(
    "notuniversal",
    "high",
    "all",
    LocalText(
      "A game says one action always works with tigers. How should you judge that claim?",
      "खेल कहता है एक उपाय बाघ पर हमेशा काम करता है। इस दावे को कैसे परखें?",
      "खेळ म्हणतो वाघासाठी एक कृती नेहमीच चालते. दावा कसा तपासाल?",
    ),
    [
      LocalText(
        "Reject the guarantee; situations differ.",
        "गारंटी न मानें; स्थितियाँ अलग होती हैं।",
        "हमी नाकारा; परिस्थिती बदलते.",
      ),
      LocalText(
        "Trust it because it is a game.",
        "खेल है इसलिए भरोसा करें।",
        "खेळ आहे म्हणून विश्वास ठेवा.",
      ),
      LocalText(
        "Try it on the next tiger.",
        "अगले बाघ पर आज़माएँ।",
        "पुढच्या वाघावर करून पाहा.",
      ),
      LocalText(
        "Apply it to every animal.",
        "हर जानवर पर लागू करें।",
        "प्रत्येक प्राण्यासाठी वापरा.",
      ),
    ],
    LocalText(
      "No game can guarantee an outcome in a real wildlife encounter.",
      "असली वन्यजीव सामना कैसा होगा, कोई खेल गारंटी नहीं दे सकता।",
      "खऱ्या वन्यजीव भेटीच्या परिणामाची हमी कोणताही खेळ देऊ शकत नाही.",
    ),
  ),
  ForestQuestion(
    "distanceclaim",
    "high",
    "all",
    LocalText(
      "A visitor quotes a distance rule from another reserve. Your guide requires more space here. What takes priority?",
      "कोई दूसरे अभयारण्य की दूरी बताता है। यहाँ गाइड अधिक दूरी कहता है। प्राथमिकता किसे?",
      "कोणी दुसऱ्या अभयारण्याचे अंतर सांगते. इथे मार्गदर्शक अधिक अंतर सांगतो. प्राधान्य कशाला?",
    ),
    [
      LocalText(
        "This reserve’s current instructions.",
        "इस अभयारण्य के वर्तमान निर्देश।",
        "या अभयारण्याचे सध्याचे निर्देश.",
      ),
      LocalText(
        "The smaller quoted number.",
        "बताई गई छोटी संख्या।",
        "सांगितलेला लहान आकडा.",
      ),
      LocalText(
        "Whatever fits the photograph.",
        "फोटो के अनुसार दूरी।",
        "फोटोला योग्य अंतर.",
      ),
      LocalText(
        "The loudest visitor’s opinion.",
        "सबसे ऊँची आवाज़ वाले की राय।",
        "मोठ्याने बोलणाऱ्याचे मत.",
      ),
    ],
    LocalText(
      "Do not treat a rule from another location as universal.",
      "दूसरी जगह का नियम हर जगह लागू नहीं होता।",
      "दुसऱ्या ठिकाणचा नियम सर्वत्र लागू समजू नका.",
    ),
  ),
  ForestQuestion(
    "pressure",
    "high",
    "all",
    LocalText(
      "Everyone wants a closer view, but the guide says it would crowd the tiger. What is the sound decision?",
      "सब पास से देखना चाहते हैं, पर गाइड कहता है बाघ घिर जाएगा। सही निर्णय?",
      "सर्वांना जवळून पाहायचे, पण वाघ घेरला जाईल असे मार्गदर्शक सांगतो. योग्य निर्णय?",
    ),
    [
      LocalText(
        "Support space despite group pressure.",
        "दबाव के बावजूद दूरी का समर्थन करें।",
        "दबाव असूनही अंतराला पाठिंबा द्या.",
      ),
      LocalText(
        "Vote to overrule the guide.",
        "मतदान से गाइड को रोकें।",
        "मतदानाने मार्गदर्शकाला नाकारा.",
      ),
      LocalText(
        "Approach because most people agree.",
        "अधिकतर सहमत हैं तो पास जाएँ।",
        "बहुमत आहे म्हणून जवळ जा.",
      ),
      LocalText(
        "Take turns getting close.",
        "बारी-बारी पास जाएँ।",
        "आळीपाळीने जवळ जा.",
      ),
    ],
    LocalText(
      "A majority preference does not remove a wildlife risk.",
      "बहुमत की इच्छा से वन्यजीव का खतरा नहीं मिटता।",
      "बहुमताची इच्छा वन्यजीवाचा धोका दूर करत नाही.",
    ),
  ),
  ForestQuestion(
    "quietcontext",
    "high",
    "all",
    LocalText(
      "Quiet viewing suits an undisturbed safari sighting. Can you apply it to every emergency?",
      "शांत सफारी दर्शन में चुप रहना सही है। क्या हर आपात स्थिति में यही लागू है?",
      "शांत सफारी दर्शनात शांत राहणे योग्य. प्रत्येक आपत्कालीन प्रसंगात तेच लागू का?",
    ),
    [
      LocalText(
        "No; context and trained advice matter.",
        "नहीं; स्थिति और प्रशिक्षित सलाह ज़रूरी हैं।",
        "नाही; परिस्थिती आणि प्रशिक्षित सल्ला महत्त्वाचा.",
      ),
      LocalText(
        "Yes; every encounter is identical.",
        "हाँ; हर सामना एक जैसा है।",
        "हो; प्रत्येक भेट सारखीच असते.",
      ),
      LocalText(
        "Yes; animals never react differently.",
        "हाँ; जानवर हमेशा एक जैसे रहते हैं।",
        "हो; प्राणी वेगळे वागतच नाहीत.",
      ),
      LocalText(
        "Ignore all local advice.",
        "सारी स्थानीय सलाह छोड़ें।",
        "सर्व स्थानिक सल्ला दुर्लक्षित करा.",
      ),
    ],
    LocalText(
      "Advice for calm viewing is not a universal emergency response.",
      "शांत दर्शन की सलाह हर आपात स्थिति का एक ही उत्तर नहीं है।",
      "शांत दर्शनाचा सल्ला हा प्रत्येक आपत्कालीन प्रसंगाचा एकच उपाय नाही.",
    ),
  ),
  ForestQuestion(
    "child_low",
    "low",
    "child",
    LocalText(
      "On a guided family visit, you see tiger tracks. Who should you tell?",
      "परिवार की निर्देशित यात्रा में बाघ के निशान दिखे। किसे बताएँ?",
      "कुटुंबाच्या मार्गदर्शित भेटीत वाघाच्या खुणा दिसल्या. कोणाला सांगाल?",
    ),
    [
      LocalText(
        "Your trusted adult and guide.",
        "अपने भरोसेमंद बड़े और गाइड को।",
        "विश्वासू मोठ्या व्यक्तीला आणि मार्गदर्शकाला.",
      ),
      LocalText(
        "Nobody; follow alone.",
        "किसी को नहीं; अकेले जाएँ।",
        "कोणालाही नाही; एकटे जा.",
      ),
      LocalText("Only a toy animal.", "सिर्फ खिलौने को।", "फक्त खेळण्याला."),
      LocalText("A friend far away.", "दूर के दोस्त को।", "दूरच्या मित्राला."),
    ],
    LocalText(
      "Stay with your trusted adult and guide; do not follow tracks.",
      "भरोसेमंद बड़े और गाइड के साथ रहें; निशानों का पीछा न करें।",
      "विश्वासू मोठ्या व्यक्तीसोबत आणि मार्गदर्शकासोबत राहा; खुणांचा पाठलाग नको.",
    ),
  ),
  ForestQuestion(
    "child_medium",
    "medium",
    "child",
    LocalText(
      "Your friend wants to touch a cub. Your guide says stay away. Whom should you follow?",
      "दोस्त बाघ के बच्चे को छूना चाहता है। गाइड दूर रहने को कहता है। किसकी सुनें?",
      "मित्राला वाघाच्या पिल्लाला हात लावायचा आहे. मार्गदर्शक दूर राहायला सांगतो. कोणाचे ऐकाल?",
    ),
    [
      LocalText(
        "The guide; ask your friend to stay back.",
        "गाइड की; दोस्त को भी दूर रखें।",
        "मार्गदर्शकाचे; मित्रालाही मागे राहायला सांगा.",
      ),
      LocalText(
        "Your friend for fun.",
        "मज़े के लिए दोस्त की।",
        "मजेसाठी मित्राचे.",
      ),
      LocalText(
        "The person with a camera.",
        "कैमरे वाले की।",
        "कॅमेरा असलेल्याचे.",
      ),
      LocalText(
        "Whoever speaks first.",
        "जो पहले बोले उसकी।",
        "आधी बोलेल त्याचे.",
      ),
    ],
    LocalText(
      "A friend’s excitement does not make a cub safe to approach.",
      "दोस्त का उत्साह बच्चे के पास जाना सुरक्षित नहीं बनाता।",
      "मित्राचा उत्साह पिल्लाजवळ जाणे सुरक्षित करत नाही.",
    ),
  ),
  ForestQuestion(
    "child_high",
    "high",
    "child",
    LocalText(
      "An online video says feeding animals is kind. Your guide says it harms them. Which reason is stronger?",
      "वीडियो कहता है जानवरों को खिलाना दया है। गाइड कहता है हानि होती है। मजबूत कारण कौन सा?",
      "व्हिडिओ म्हणतो खाऊ घालणे दया आहे. मार्गदर्शक म्हणतो नुकसान होते. ठोस कारण कोणते?",
    ),
    [
      LocalText(
        "Feeding can change wild behaviour.",
        "खिलाने से जंगली व्यवहार बदल सकता है।",
        "खाऊ घातल्याने जंगली वर्तन बदलू शकते.",
      ),
      LocalText(
        "The video has more likes.",
        "वीडियो के अधिक लाइक हैं।",
        "व्हिडिओला जास्त लाइक आहेत.",
      ),
      LocalText(
        "The food looks tasty.",
        "खाना स्वादिष्ट दिखता है।",
        "अन्न चविष्ट दिसते.",
      ),
      LocalText(
        "The animal looks cute.",
        "जानवर प्यारा है।",
        "प्राणी गोंडस आहे.",
      ),
    ],
    LocalText(
      "Judge the reason, not the popularity of a video.",
      "वीडियो की लोकप्रियता नहीं, कारण को परखें।",
      "व्हिडिओची लोकप्रियता नव्हे, कारण तपासा.",
    ),
  ),
  ForestQuestion(
    "young_low",
    "low",
    "young",
    LocalText(
      "A friend proposes a tiger selfie outside the safari vehicle. Your response?",
      "दोस्त सफारी वाहन से बाहर बाघ संग सेल्फी चाहता है। आपका जवाब?",
      "मित्राला सफारी वाहनाबाहेर वाघासोबत सेल्फी हवी आहे. तुमचे उत्तर?",
    ),
    [
      LocalText(
        "Decline and stay inside.",
        "मना करें और अंदर रहें।",
        "नकार द्या आणि आत राहा.",
      ),
      LocalText("Accept the dare.", "चुनौती स्वीकारें।", "आव्हान स्वीकारा."),
      LocalText(
        "Hold the door for them.",
        "उसके लिए दरवाज़ा पकड़ें।",
        "त्याच्यासाठी दार धरा.",
      ),
      LocalText("Go first.", "पहले खुद जाएँ।", "आधी स्वतः जा."),
    ],
    LocalText(
      "Do not leave the vehicle for a wildlife selfie.",
      "वन्यजीव सेल्फी के लिए वाहन से बाहर न निकलें।",
      "वन्यजीव सेल्फीसाठी वाहनाबाहेर उतरू नका.",
    ),
  ),
  ForestQuestion(
    "young_medium",
    "medium",
    "young",
    LocalText(
      "Your group dares you to cross a closed trail barrier. What do you do?",
      "समूह आपको बंद राह की रोक पार करने की चुनौती देता है। क्या करें?",
      "गट बंद वाटेचा अडथळा ओलांडण्याचे आव्हान देतो. काय कराल?",
    ),
    [
      LocalText(
        "Refuse and suggest the open route.",
        "मना करें और खुली राह सुझाएँ।",
        "नकार द्या आणि खुली वाट सुचवा.",
      ),
      LocalText(
        "Cross to prove courage.",
        "हिम्मत साबित करने को पार करें।",
        "धाडस दाखवायला ओलांडा.",
      ),
      LocalText(
        "Film a friend crossing.",
        "दोस्त को पार करते फिल्माएँ।",
        "मित्र ओलांडताना चित्रण करा.",
      ),
      LocalText(
        "Cross when staff leave.",
        "कर्मचारी जाएँ तब पार करें।",
        "कर्मचारी गेल्यावर ओलांडा.",
      ),
    ],
    LocalText(
      "A safe choice can mean resisting peer pressure.",
      "सुरक्षित निर्णय के लिए साथियों के दबाव का विरोध करना पड़ सकता है।",
      "सुरक्षित निर्णयासाठी मित्रांच्या दबावाला विरोध करावा लागू शकतो.",
    ),
  ),
  ForestQuestion(
    "young_high",
    "high",
    "young",
    LocalText(
      "A viral post promises a safe secret tiger trail. No official source confirms it. What is rational?",
      "वायरल पोस्ट सुरक्षित गुप्त बाघ राह का दावा करती है। अधिकृत पुष्टि नहीं। समझदारी क्या है?",
      "व्हायरल पोस्ट सुरक्षित गुप्त व्याघ्रवाट सांगते. अधिकृत खात्री नाही. योग्य विचार?",
    ),
    [
      LocalText(
        "Check authorised guidance; do not enter on that claim.",
        "अधिकृत सलाह जाँचें; दावे पर प्रवेश न करें।",
        "अधिकृत मार्गदर्शन तपासा; दाव्यावरून जाऊ नका.",
      ),
      LocalText(
        "Trust the high view count.",
        "अधिक व्यूज़ पर भरोसा करें।",
        "जास्त व्ह्यूवर विश्वास ठेवा.",
      ),
      LocalText(
        "Go because friends shared it.",
        "दोस्तों ने भेजा तो जाएँ।",
        "मित्रांनी पाठवले म्हणून जा.",
      ),
      LocalText(
        "Assume secret means safer.",
        "गुप्त है तो सुरक्षित मानें।",
        "गुप्त म्हणजे सुरक्षित समजा.",
      ),
    ],
    LocalText(
      "Popularity is not verification of safety or permission.",
      "लोकप्रियता सुरक्षा या अनुमति का प्रमाण नहीं है।",
      "लोकप्रियता म्हणजे सुरक्षा किंवा परवानगीचा पुरावा नाही.",
    ),
  ),
  ForestQuestion(
    "adult_low",
    "low",
    "adult",
    LocalText(
      "You are arranging a forest visit for your family. What comes first?",
      "परिवार की वन यात्रा की योजना है। पहले क्या करें?",
      "कुटुंबाची वनभेट ठरवत आहात. आधी काय कराल?",
    ),
    [
      LocalText(
        "Check permits, routes and authorised guides.",
        "अनुमति, राह और अधिकृत गाइड जाँचें।",
        "परवानग्या, वाटा आणि अधिकृत मार्गदर्शक तपासा.",
      ),
      LocalText(
        "Plan an unapproved shortcut.",
        "अनुमति बिना छोटी राह चुनें।",
        "अनधिकृत जवळची वाट ठरवा.",
      ),
      LocalText(
        "Promise a close tiger photo.",
        "पास से बाघ के फोटो का वादा करें।",
        "जवळून वाघाचा फोटो देण्याचे वचन द्या.",
      ),
      LocalText(
        "Ignore entry rules.",
        "प्रवेश नियम अनदेखे करें।",
        "प्रवेश नियम दुर्लक्षित करा.",
      ),
    ],
    LocalText(
      "Plan within current access rules rather than around a promised sighting.",
      "निश्चित दर्शन के बजाय वर्तमान प्रवेश नियमों के अनुसार योजना बनाएँ।",
      "दर्शनाच्या वचनाऐवजी सध्याच्या प्रवेश नियमांनुसार योजना करा.",
    ),
  ),
  ForestQuestion(
    "adult_medium",
    "medium",
    "adult",
    LocalText(
      "Your schedule is late. A closed shortcut would save time. What should you prioritise?",
      "समय कम है। बंद छोटी राह समय बचाएगी। प्राथमिकता क्या हो?",
      "वेळ कमी आहे. बंद जवळची वाट वेळ वाचवेल. प्राधान्य कशाला?",
    ),
    [
      LocalText(
        "Adjust the schedule and respect the closure.",
        "समय-योजना बदलें; बंद राह का सम्मान करें।",
        "वेळापत्रक बदला; बंदी पाळा.",
      ),
      LocalText(
        "Use the shortcut just once.",
        "बस एक बार छोटी राह लें।",
        "एकदाच जवळची वाट घ्या.",
      ),
      LocalText(
        "Ask the family to hurry through.",
        "परिवार को जल्दी पार कराएँ।",
        "कुटुंबाला घाईने नेऊन या.",
      ),
      LocalText(
        "Ignore the barrier if it looks empty.",
        "खाली दिखे तो रोक अनदेखी करें।",
        "रिकामे दिसले तर अडथळा दुर्लक्षित करा.",
      ),
    ],
    LocalText(
      "Schedule pressure does not justify entering a closed area.",
      "समय का दबाव बंद क्षेत्र में प्रवेश का कारण नहीं बनता।",
      "वेळेचा ताण बंद भागात प्रवेशाचे समर्थन करत नाही.",
    ),
  ),
  ForestQuestion(
    "adult_high",
    "high",
    "adult",
    LocalText(
      "Two plans fit your budget: an authorised guided visit or an unverified close-encounter offer. Which evidence matters?",
      "दो योजनाएँ बजट में हैं: अधिकृत गाइड वाली यात्रा या अपुष्ट नज़दीकी सामना। क्या अहम है?",
      "दोन योजना बजेटमध्ये: अधिकृत मार्गदर्शित भेट किंवा अप्रमाणित जवळची भेट. काय महत्त्वाचे?",
    ),
    [
      LocalText(
        "Verified permission and qualified local guidance.",
        "सत्यापित अनुमति और योग्य स्थानीय मार्गदर्शन।",
        "पडताळलेली परवानगी आणि पात्र स्थानिक मार्गदर्शन.",
      ),
      LocalText("Only the lower price.", "केवल कम कीमत।", "फक्त कमी किंमत."),
      LocalText(
        "A promise of guaranteed proximity.",
        "ज़रूर पास जाने का वादा।",
        "जवळ जाण्याची हमी.",
      ),
      LocalText(
        "A dramatic advertisement.",
        "नाटकीय विज्ञापन।",
        "नाट्यमय जाहिरात.",
      ),
    ],
    LocalText(
      "Evaluate legitimacy and risk before price or spectacle.",
      "कीमत या रोमांच से पहले वैधता और जोखिम परखें।",
      "किंमत किंवा थराराआधी वैधता आणि धोका तपासा.",
    ),
  ),
  ForestQuestion(
    "older_low",
    "low",
    "older",
    LocalText(
      "You return to a reserve after many years. What should you check?",
      "कई वर्षों बाद अभयारण्य लौटे हैं। क्या जाँचें?",
      "अनेक वर्षांनी अभयारण्यात परत आलात. काय तपासाल?",
    ),
    [
      LocalText(
        "Today’s rules and authorised routes.",
        "आज के नियम और अधिकृत राहें।",
        "आजचे नियम आणि अधिकृत वाटा.",
      ),
      LocalText(
        "Only what you remember.",
        "केवल अपनी याद।",
        "फक्त तुमच्या आठवणी.",
      ),
      LocalText(
        "The route from an old photo.",
        "पुराने फोटो का रास्ता।",
        "जुन्या फोटोतील वाट.",
      ),
      LocalText(
        "A decades-old timetable.",
        "दशकों पुरानी समय-सारणी।",
        "अनेक वर्षांपूर्वीचे वेळापत्रक.",
      ),
    ],
    LocalText(
      "Local access rules can change; check current information.",
      "स्थानीय प्रवेश नियम बदल सकते हैं; वर्तमान जानकारी लें।",
      "स्थानिक प्रवेश नियम बदलू शकतात; सध्याची माहिती घ्या.",
    ),
  ),
  ForestQuestion(
    "older_medium",
    "medium",
    "older",
    LocalText(
      "You want a different pace from your group. What is a sensible plan?",
      "आप समूह से अलग गति चाहते हैं। समझदार योजना क्या है?",
      "तुम्हाला गटापेक्षा वेगळी गती हवी आहे. समंजस योजना?",
    ),
    [
      LocalText(
        "Discuss permitted options with the guide.",
        "गाइड से अनुमत विकल्पों पर बात करें।",
        "मार्गदर्शकाशी अनुमत पर्यायांवर चर्चा करा.",
      ),
      LocalText(
        "Leave the group unannounced.",
        "बिना बताए समूह छोड़ें।",
        "न सांगता गट सोडा.",
      ),
      LocalText(
        "Take a closed path alone.",
        "अकेले बंद राह लें।",
        "एकटे बंद वाट घ्या.",
      ),
      LocalText(
        "Ask others to ignore the rules.",
        "सबको नियम तोड़ने को कहें।",
        "इतरांना नियम मोडायला सांगा.",
      ),
    ],
    LocalText(
      "Communicate preferences and plan within authorised options.",
      "अपनी पसंद बताएँ और अनुमत विकल्पों में योजना बनाएँ।",
      "तुमची पसंती सांगा आणि अधिकृत पर्यायांत योजना करा.",
    ),
  ),
  ForestQuestion(
    "older_high",
    "high",
    "older",
    LocalText(
      "Past experience says a trail was safe. New ranger information says wildlife activity has changed. What should lead your decision?",
      "अनुभव कहता है राह सुरक्षित थी। नई वनरक्षक सूचना कहती है गतिविधि बदली है। निर्णय कैसे लें?",
      "अनुभवानुसार वाट सुरक्षित होती. वनरक्षकाची नवी माहिती बदललेली हालचाल सांगते. निर्णय कसा घ्याल?",
    ),
    [
      LocalText(
        "Combine experience with current official advice.",
        "अनुभव संग वर्तमान अधिकृत सलाह लें।",
        "अनुभवासोबत सध्याचा अधिकृत सल्ला वापरा.",
      ),
      LocalText(
        "Treat memory as a guarantee.",
        "याद को गारंटी मानें।",
        "आठवणीला हमी समजा.",
      ),
      LocalText(
        "Dismiss the new warning.",
        "नई चेतावनी छोड़ दें।",
        "नवा इशारा नाकारा.",
      ),
      LocalText(
        "Assume familiar means risk-free.",
        "परिचित को जोखिम-मुक्त मानें।",
        "ओळखीचे म्हणजे धोकामुक्त समजा.",
      ),
    ],
    LocalText(
      "Experience is valuable, but conditions and evidence can change.",
      "अनुभव उपयोगी है, पर स्थिति और प्रमाण बदल सकते हैं।",
      "अनुभव मोलाचा आहे, पण परिस्थिती आणि पुरावे बदलू शकतात.",
    ),
  ),
];
